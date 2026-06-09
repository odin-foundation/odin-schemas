; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance Documents Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Document attachment definitions for binders, insurance cards, declaration pages,
; policy forms, endorsement forms, and other associated insurance files.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.documents"
version = "1.0.0"
title = "Insurance Documents Schema"
description = "Document and file attachment definitions"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-13
changelog[0].change = "Initial documents schema"
changelog[0].rationale = "Standard document management structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Generic Document/Attachment
; ═══════════════════════════════════════════════════════════════════════════════

{@document}
id = :

; Classification
type = (
    application,
    binder,
    cancellation_notice,
    certificate,
    claim_form,
    clue_report,
    correspondence,
    dec_page,
    endorsement_form,
    estimate,
    id_card,
    inspection_report,
    invoice,
    mvr_report,
    other,
    payment_receipt,
    photo,
    policy_form,
    proof_of_loss,
    renewal_notice
)
sub_type = :
description = :

; File information
filename = :
mime_type = :
file_size = ##                                 ; Bytes
file_hash = :                                  ; SHA-256 hash
file_data = ^                                  ; Base64 encoded, max 100MB

; Storage reference (alternative to inline data)
storage_type = (azure, inline, local, s3, url)
storage_url = :
storage_bucket = :
storage_key = :

; Metadata
created = timestamp
created_by = :
modified = timestamp
effective = date
expiration = date

; Version control
version = ##
supersedes = :                                 ; Previous document id

; Access control
confidential = ?
internal_only = ?

; ═══════════════════════════════════════════════════════════════════════════════
; Binder Document
; ═══════════════════════════════════════════════════════════════════════════════

{@binder_document}
id = :
type = "binder"

; Binder details
number = :
date = date
time = time
days = ##                               ; Days binder is in effect
expiration = date
:invariant expiration >= date

; Status
status = (active, cancelled, expired, replaced)
replaced_by_policy = :                         ; Policy number when bound

; File
filename = :
file_data = ^                                  ; Max 10MB
storage_url = :

; Audit
created = timestamp
created_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Declarations Page
; ═══════════════════════════════════════════════════════════════════════════════

{@dec_page}
id = :
type = "dec_page"

; Policy reference
policy_number = :
effective_date = date
expiration_date = date
transaction_type = (endorsement, new_business, reinstatement, renewal, rewrite)
endorsement_number = :if transaction_type = endorsement

; Version
version = ##
issue_date = date

; File
filename = :
file_data = ^                                  ; Max 10MB
storage_url = :

; Audit
created = timestamp
created_by = :

; ═══════════════════════════════════════════════════════════════════════════════
; Insurance ID Card
; ═══════════════════════════════════════════════════════════════════════════════

{@insurance_card}
id = :
type = "id_card"

; Policy reference
policy_number = :
effective_date = date
expiration_date = date

; Card specific
card_type = (digital, fr44, sr22, standard)
state_province = :(2)                         ; US state or Canadian province

; Vehicle (for auto)
vehicle_vin = *:(17)
vehicle_year = ##:(1900..2100)
vehicle_make = :
vehicle_model = :

; File
filename = :
file_data = ^                                  ; Max 5MB
storage_url = :
digital_card_url = :                           ; Link for digital card

; Audit
created = timestamp
issued_to = :

; ═══════════════════════════════════════════════════════════════════════════════
; Policy Form
; ═══════════════════════════════════════════════════════════════════════════════

{@policy_form}
id = :
type = "policy_form"

; Form identification
number = :
name = :
edition = :                               ; Edition date like "01/2024"

; Classification
form_type = (application, coverage_form, endorsement, exclusion, notice, policy_jacket, schedule)
line_of_business = (auto, commercial, home, other, umbrella)
state_province = :(2)                          ; State/province-specific or "XX"/"CA" for nationwide
mandatory = ?                                  ; Required by jurisdiction or carrier

; Effective dates
effective_date = date
withdrawn_date = date

; File
filename = :
file_data = ^                                  ; Max 20MB
storage_url = :
page_count = ##

; ═══════════════════════════════════════════════════════════════════════════════
; MVR Report
; ═══════════════════════════════════════════════════════════════════════════════

{@mvr_report}
id = :
type = "mvr_report"

; Subject
driver_name = :
drivers_license = *!:
license_state_province = :(2)                ; US state or Canadian province
date_of_birth = *!date

; Report details
order_date = date
report_date = date
vendor = :
reference_number = :

; Status
status = (error, not_found, ordered, received)
error_message = :

; File (report document)
filename = :
file_data = ^
storage_url = :

; ═══════════════════════════════════════════════════════════════════════════════
; CLUE Report (Claims History)
; ═══════════════════════════════════════════════════════════════════════════════

{@clue_report}
id = :
type = "clue_report"

; Subject
subject_name = :                            ; Subject name
subject_ssn = *:format ssn                    ; US Social Security Number
subject_sin = *:/^\d{3}-\d{3}-\d{3}$/         ; Canadian Social Insurance Number
subject_address = @address                   ; Subject address

; Report details
order_date = date
report_date = date
report_type = (auto, comprehensive, property)
vendor = :
reference_number = :

; Status
status = (error, no_hits, ordered, received)

; File
filename = :
file_data = ^
storage_url = :

; ═══════════════════════════════════════════════════════════════════════════════
; Document Collection (for grouping)
; ═══════════════════════════════════════════════════════════════════════════════

{@document_collection}
id = :
name = :
description = :

; References to documents
document_ids[] = :

; Metadata
created = timestamp
created_by = :

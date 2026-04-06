; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance Agency Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Insurance agency, producer, and customer service representative (CSR) definitions
; for agency management across all insurance lines.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.common.agency"
version = "1.0.0"
title = "Insurance Agency Schema"
description = "Agency, producer, and CSR definitions"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-13
changelog[0].change = "Initial agency schema"
changelog[0].rationale = "Standard agency and producer data structures"

; ═══════════════════════════════════════════════════════════════════════════════
; Agency
; ═══════════════════════════════════════════════════════════════════════════════
; Composes from @organization, adds agency-specific fields.

{@agency}
= @organization                               ; Inherits org fields

; Agency-specific identification
id = :                                        ; Agency identifier
code = :                                      ; Agency code
license_number = *:                           ; Agency license number
license_state_province = :(2)                 ; License jurisdiction

; Banking (agency-specific)
{.bank}
routing = *:(9)                               ; Bank routing number
account = *:                                  ; Bank account number
name = :                                      ; Bank name
account_type = (checking, savings)            ; Account type

; E&O Insurance (agency-specific)
{.eo}
carrier = :                                   ; E&O carrier name
policy_number = :                             ; E&O policy number
expiration = date                             ; E&O expiration date
limit = #$:(0..)                              ; E&O coverage limit

; ═══════════════════════════════════════════════════════════════════════════════
; Producer (Licensed Agent)
; ═══════════════════════════════════════════════════════════════════════════════

{@producer}
= @person                                     ; Inherits person fields (name, contact)

id = :
code = :
npn = :

; Override required name fields
{.name}
first = !:                                    ; First name (required)
last = !:                                     ; Last name (required)

{@producer}

; Licensing
{.license}
number = *:
state_province = :(2)
type = (non_resident, resident)
expiration = date
status = (active, inactive, revoked, suspended)

{@producer}

; Appointments
appointed_carriers[] = :

; Commission
commission_split = #:(0..100)

; ═══════════════════════════════════════════════════════════════════════════════
; CSR (Customer Service Representative)
; ═══════════════════════════════════════════════════════════════════════════════

{@csr}
= @person                                     ; Inherits person fields (name, contact)

id = :
code = :

; Override required name fields
{.name}
first = !:                                    ; First name (required)
last = !:                                     ; Last name (required)

{@csr}

; Status
active = ?
hire_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Quote/Service Attribution
; ═══════════════════════════════════════════════════════════════════════════════

{@service_attribution}
{.quoted_by}
first = :
last = :
initial = :

{@service_attribution}
quoted_date = date

{.written_by}
first = :
last = :
initial = :

{@service_attribution}
written_date = date

{.last_serviced_by}
first = :
last = :
initial = :

{@service_attribution}
last_serviced_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; Lead/Marketing Source
; ═══════════════════════════════════════════════════════════════════════════════

{@lead_source}
contact_source = :
lead_source = :
referral_name = :
marketing_code = :

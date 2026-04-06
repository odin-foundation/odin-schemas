; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Utilities/Energy - Customer Account Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Customer account information for electric, gas, and water utilities including
; account status, service locations, rate classifications, budget billing,
; and payment arrangements.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.utilities.account"
version = "1.0.0"
title = "Utility Customer Account"
description = "Customer account schema for electric, gas, and water utilities"

{$derivation}
source[0].authority = "North American Energy Standards Board"
source[0].citation = "NAESB WEQ-012 Customer Account Information"
source[0].url = "https://www.naesb.org/"
source[0].accessed = 2025-12-21

source[1].authority = "Federal Energy Regulatory Commission"
source[1].citation = "18 CFR Part 35 - Filed Rate Doctrine"
source[1].url = "https://www.ecfr.gov/current/title-18/chapter-I/subchapter-B/part-35"
source[1].accessed = 2025-12-21

source[2].authority = "National Association of Regulatory Utility Commissioners"
source[2].citation = "Customer Information System Standards"
source[2].url = "https://www.naruc.org/"
source[2].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial utilities account schema"
changelog[0].rationale = "Standard utility customer account structure per NAESB and FERC requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT
; ═══════════════════════════════════════════════════════════════════════════════

{@account}
; Required fields first
account_number = !*:                                ; Unique account identifier
customer_type = (commercial, government, industrial, residential)
status = (active, closed, inactive, pending, suspended)

; Service address (where utility is delivered)
service_address = !@address

; Optional fields
account_name = :                                   ; Display name for account
customer_class = :                                 ; Utility-specific customer classification
enrolled_date = date                               ; Date account established
status_date = date                                 ; Date of last status change
status_reason = :                                  ; Reason for status change

; Billing address (if different from service)
billing_address = @address                         ; Billing correspondence address
billing_same_as_service = ?                        ; Flag if billing matches service address

; Account lifecycle
opened_date = date                                 ; Account opening date
closed_date = date                                 ; Account closure date
close_reason = :                                   ; Reason for closure
reactivated_date = date                            ; Last reactivation date

; Customer preferences
paperless_billing = ?                              ; Electronic billing preference
auto_pay = ?                                       ; Automatic payment enrollment
payment_due_day = ##:(1..28)                       ; Preferred due day of month

; Account notes
notes = :                                          ; General account notes
special_instructions = :                           ; Service or billing instructions

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMER INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════

{@account.customer}
; Required fields
customer_id = !:                                   ; Master customer identifier

; Personal information (for residential)
name = @person_name                                ; Customer name
date_of_birth = *date                              ; Date of birth (identity verification)
ssn = *:format ssn                                 ; Social Security Number
drivers_license = *:                               ; Driver license number
drivers_license_state = :(2)                       ; State of issuance

; Business information (for commercial/industrial)
business_name = :                                  ; Legal business name
dba_name = :                                       ; Doing business as name
tax_id = *:                                        ; EIN or tax ID
business_type = (corporation, llc, partnership, sole_proprietor)
industry_code = :                                  ; NAICS or SIC code

; Contact information
phones[] = *@phone                                 ; Phone numbers
emails[] = *@email                                 ; Email addresses
preferred_contact_method = (email, mail, phone, sms)

; Contact preferences
= @types.contact_preference                        ; From common types

; Language preference
preferred_language = :(2..3)                       ; ISO language code
interpreter_needed = ?                             ; Interpreter services required

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; AUTHORIZED CONTACTS
; ═══════════════════════════════════════════════════════════════════════════════

{@account.authorized_contacts[]}
name = !@person_name                               ; Contact name
relationship = :                                   ; Relationship to account holder
phones[] = *@phone                                 ; Contact phone numbers
emails[] = *@email                                 ; Contact email addresses
authorization_level = (billing, emergency, full, service)
effective_date = date                              ; Authorization start date
expiration_date = date                             ; Authorization end date

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; SERVICE LOCATION
; ═══════════════════════════════════════════════════════════════════════════════

{@service_location}
; Required fields
location_id = !:                                   ; Unique service location identifier
address = !@address                                ; Service delivery address

; Optional fields
premise_type = (apartment, commercial, house, industrial, multi_family, other)
premise_description = :                            ; Physical description
access_instructions = :                            ; Access notes for field personnel
access_restrictions = :                            ; Access limitations or requirements

; GPS coordinates
latitude = #:(-90..90)                             ; Latitude
longitude = #:(-180..180)                          ; Longitude

; Service territory
utility_territory = :                              ; Service territory code
jurisdiction = :                                   ; Regulatory jurisdiction
district = :                                       ; Service district
zone = :                                           ; Service zone

; Premise characteristics
square_footage = ##:(0..)                          ; Building square footage
lot_size = #:(0..)                                 ; Lot size in acres
year_built = ##:(1800..)                           ; Year constructed
occupancy_type = (mixed_use, multi_tenant, owner_occupied, rental, vacant)
unit_count = ##:(1..)                              ; Units in building

; Safety and access
hazardous_location = ?                             ; Safety hazard flag
locked_gate = ?                                    ; Locked gate access
dog_on_property = ?                                ; Dog warning
keys_required = ?                                  ; Key access required
escort_required = ?                                ; Escort needed for access

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; RATE INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════

{@account.rate}
; Required fields
rate_code = !:                                     ; Current rate schedule code
rate_class = !:                                    ; Rate classification

; Optional fields
rate_description = :                               ; Rate schedule name
tariff_number = :                                  ; Filed tariff reference
effective_date = date                              ; Rate effective date
rider_codes[] = :                                  ; Additional rate riders or surcharges

; Load characteristics (commercial/industrial)
demand_subscription = #:(0..)                      ; Subscribed demand in kW
contract_demand = #:(0..)                          ; Contracted demand level
load_factor = #:(0..100)                           ; Load factor percentage
power_factor = #:(0..100)                          ; Power factor percentage

; Special programs
time_of_use = ?                                    ; Time-of-use rate
net_metering = ?                                   ; Net metering enrolled
interruptible = ?                                  ; Interruptible service
economy_rate = ?                                   ; Economy rate participant

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; BUDGET BILLING
; ═══════════════════════════════════════════════════════════════════════════════

{@account.budget_billing}
enrolled = !?                                      ; Budget billing enrollment status
monthly_amount = #$:(0..)                          ; Fixed monthly payment amount
start_date = date                                  ; Budget billing start date
review_date = date                                 ; Next review/adjustment date
review_month = ##:(1..12)                          ; Annual review month
actual_balance = #$                                ; Cumulative actual vs budget
reconciliation_due = #$                            ; Amount due at reconciliation

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; PAYMENT ARRANGEMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@account.payment_arrangement}
type = (deferred, extended, installment, other)   ; Arrangement type
status = (active, completed, defaulted, pending)  ; Arrangement status
original_amount = !#$:(0..)                        ; Total amount arranged
remaining_balance = #$:(0..)                       ; Remaining balance
installment_amount = #$:(0..)                      ; Regular installment payment
installment_count = ##:(1..)                       ; Total installments
installments_remaining = ##:(0..)                  ; Installments remaining
start_date = date                                  ; Arrangement start date
end_date = date                                    ; Expected completion date
next_payment_due = date                            ; Next payment due date
default_date = date                                ; Date of default if applicable

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; DEPOSIT INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════

{@account.deposit}
required = !?                                      ; Deposit required flag
amount = #$:(0..)                                  ; Deposit amount held
date_collected = date                              ; Date deposit collected
date_due = date                                    ; Date deposit due
waived = ?                                         ; Deposit waived flag
waiver_reason = :                                  ; Reason for waiver
interest_rate = #:(0..100)                         ; Interest rate on deposit
interest_accrued = #$:(0..)                        ; Accrued interest amount
refund_date = date                                 ; Date refunded to customer
refund_amount = #$:(0..)                           ; Amount refunded

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; CREDIT AND COLLECTIONS
; ═══════════════════════════════════════════════════════════════════════════════

{@account.credit}
credit_score = ##:(300..850)                       ; Credit score
credit_class = :                                   ; Internal credit classification
credit_limit = #$:(0..)                            ; Credit limit amount
payment_history = (excellent, fair, good, new, poor)
collections_status = (active, clear, referred)     ; Collections status
last_returned_payment = date                       ; Last NSF/returned payment
returned_payment_count = ##:(0..)                  ; Count of returned payments
write_off_amount = #$                              ; Total write-off amount
write_off_date = date                              ; Last write-off date

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; ASSISTANCE PROGRAMS
; ═══════════════════════════════════════════════════════════════════════════════

{@account.assistance_programs[]}
program_code = !:                                  ; Assistance program identifier
program_name = :                                   ; Program description
enrolled_date = date                               ; Enrollment date
effective_date = date                              ; Effective start date
expiration_date = date                             ; Program expiration
status = (active, expired, pending, suspended)     ; Program enrollment status
benefit_amount = #$:(0..)                          ; Monthly benefit amount
annual_benefit_limit = #$:(0..)                    ; Annual benefit limit
benefits_received = #$:(0..)                       ; Total benefits received to date
recertification_due = date                         ; Next recertification date

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT ALERTS
; ═══════════════════════════════════════════════════════════════════════════════

{@account.alerts[]}
alert_type = (billing, collections, credit, safety, service)
severity = (critical, high, low, medium)          ; Alert severity
message = !:                                       ; Alert message
created = !timestamp                               ; Alert creation timestamp
expires = timestamp                                ; Alert expiration
acknowledged = ?                                   ; Alert acknowledged flag
acknowledged_by = :                                ; User who acknowledged
acknowledged_date = timestamp                      ; Acknowledgment timestamp

{@account}

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT HISTORY
; ═══════════════════════════════════════════════════════════════════════════════

{@account.history[]}
event_type = (closure, enrollment, modification, opening, status_change)
event_date = !timestamp                            ; Event timestamp
description = !:                                   ; Event description
performed_by = :                                   ; User who performed action
prior_value = :                                    ; Previous value if applicable
new_value = :                                      ; New value if applicable

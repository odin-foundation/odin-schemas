; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Deed Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property deed types and recording requirements including warranty, quitclaim,
; grant, trustee, executor, and sheriff deeds. Covers grantor/grantee details,
; covenants, reservations, transfer taxes, recording information, security
; instruments (deeds of trust/mortgages), and assignments.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.recording.deed"
version = "1.0.0"
title = "Real Estate Deed Schema"
description = "Property deed types and recording information"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "Title Examination Standards"
source[0].url = "https://www.alta.org/"

source[1].authority = "State Recording Statutes"
source[1].citation = "Real Property Recording Acts"
source[1].url = "https://www.law.cornell.edu/wex/recording_acts"

source[2].authority = "Uniform Real Property Electronic Recording Act"
source[2].citation = "URPERA"
source[2].url = "https://www.uniformlaws.org/committees/community-home?CommunityKey=a8f7b596-1d2c-4e4c-86df-b18a71b69b3a"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Deed schema derived from state recording statutes and title industry standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial deed schema"
changelog[0].rationale = "Comprehensive deed and recording structure"

; ═══════════════════════════════════════════════════════════════════════════════
; DEED
; ═══════════════════════════════════════════════════════════════════════════════
; Property deed document

{@deed}
; Required fields first
deed_type = !(bargain_sale, correction, deed_in_lieu, executors, general_warranty, gift, grant, guardian, personal_representative, quitclaim, sheriffs, special_warranty, tax, trust, trustees)
execution_date = !date                               ; Date deed signed
grantee = !:                                         ; Grantee name(s)
grantor = !:                                         ; Grantor name(s)
property_address = !@address                         ; Property address

; Deed identification
deed_id = :                                          ; Unique deed identifier
document_number = :                                  ; Document/instrument number

; ───────────────────────────────────────────────────────────────────────────────
; Grantor Information
; ───────────────────────────────────────────────────────────────────────────────
{.grantor}
name = :                                             ; Grantor legal name
entity_type = (corporation, estate, government, individual, llc, lp, partnership, trust)
marital_status = (divorced, married, single, widowed):if entity_type = individual
spouse_name = ::if marital_status = married          ; Spouse name (if joining)
capacity = (executor, guardian, individual, personal_rep, trustee)
capacity_document = ::if capacity != individual      ; Authority document reference
address = @address                                   ; Grantor address

{@deed}

; Additional grantors
{.grantors[]}
name = :                                             ; Grantor name
entity_type = (corporation, estate, government, individual, llc, lp, partnership, trust)
marital_status = (divorced, married, single, widowed):if entity_type = individual
capacity = (executor, guardian, individual, personal_rep, trustee)
address = @address                                   ; Grantor address

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Grantee Information
; ───────────────────────────────────────────────────────────────────────────────
{.grantee}
name = :                                             ; Grantee legal name
entity_type = (corporation, government, individual, llc, lp, partnership, trust)
vesting = (community_property, joint_tenants, sole_and_separate, tenants_by_entirety, tenants_in_common, trust)
undivided_interest = #:(0..100):if vesting = tenants_in_common
trust_date = date:if entity_type = trust | vesting = trust
trustee_name = ::if entity_type = trust | vesting = trust
address = @address                                   ; Grantee address

{@deed}

; Additional grantees
{.grantees[]}
name = :                                             ; Grantee name
entity_type = (corporation, government, individual, llc, lp, partnership, trust)
vesting = (community_property, joint_tenants, sole_and_separate, tenants_by_entirety, tenants_in_common, trust)
undivided_interest = #:(0..100):if vesting = tenants_in_common
address = @address                                   ; Grantee address

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Property Description
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers
street_address = @address                            ; Street address (for indexing)
prior_deed_reference = :                             ; Prior deed reference

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Consideration
; ───────────────────────────────────────────────────────────────────────────────
{.consideration}
consideration_type = (cash, exchange_1031, gift, love_and_affection, nominal, other)
consideration_amount = #$:(0..)                      ; Dollar consideration
other_consideration = :                              ; Other valuable consideration
subject_to_liens = ?                                 ; Subject to existing liens
assumed_liens = #$:(0..):if subject_to_liens = true  ; Amount of assumed liens

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Covenants and Warranties
; ───────────────────────────────────────────────────────────────────────────────
{.warranties}
covenant_of_seisin = ?                               ; Grantor owns property
covenant_right_to_convey = ?                         ; Grantor has right to convey
covenant_against_encumbrances = ?                    ; Free from encumbrances
covenant_quiet_enjoyment = ?                         ; Grantee won't be disturbed
covenant_warranty = ?                                ; Will defend title
covenant_further_assurances = ?                      ; Will execute needed docs
warranty_period = (during_ownership, forever, none)  ; Period of warranties

{@deed}

; Exceptions to covenants
{.warranties.exceptions[]}
exception_type = (easement, encroachment, lien, mortgage, restriction, tax_lien)
description = :                                      ; Exception description
recording_reference = :                              ; Recording reference

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Reservations and Exceptions
; ───────────────────────────────────────────────────────────────────────────────
{.reservations[]}
reservation_type = (easement, life_estate, mineral_rights, timber_rights, water_rights)
description = :                                      ; Reservation description
term = :                                             ; Term/duration
beneficiary = :                                      ; Beneficiary of reservation

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Deed Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.restrictions[]}
restriction_type = (architectural, land_use, setback, subdivision, use)
description = :                                      ; Restriction description
enforced_by = :                                      ; Who can enforce
expiration = date                                    ; Expiration date (if any)

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Execution
; ───────────────────────────────────────────────────────────────────────────────
{.execution}
execution_date = date                                ; Date signed
execution_location = :                               ; Location signed
notarized = ?                                        ; Notarized
notary_name = ::if notarized = true                  ; Notary name
notary_county = ::if notarized = true                ; Notary county
notary_state = ::if notarized = true                 ; Notary state
notary_commission_expires = date:if notarized = true ; Commission expiration
witnesses_required = ##:(0..2)                       ; Witnesses required
witness_1_name = ::if witnesses_required > 0         ; First witness
witness_2_name = ::if witnesses_required > 1         ; Second witness

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
recording = @deed_recording                          ; Recording information

; ───────────────────────────────────────────────────────────────────────────────
; Transfer Tax
; ───────────────────────────────────────────────────────────────────────────────
{.transfer_tax}
exempt = ?                                           ; Exempt from transfer tax
exemption_reason = ::if exempt = true                ; Exemption reason
taxable_value = #$:(0..):if exempt = false           ; Taxable value
state_tax = #$:(0..):if exempt = false               ; State transfer tax
county_tax = #$:(0..):if exempt = false              ; County transfer tax
city_tax = #$:(0..):if exempt = false                ; City transfer tax
total_tax = #$:(0..):if exempt = false               ; Total transfer tax

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Special Deed Types
; ───────────────────────────────────────────────────────────────────────────────
; Trustee's Deed
{.trustee_deed}
trust_name = ::if deed_type = trustees               ; Trust name
trust_date = date:if deed_type = trustees            ; Trust date
power_of_sale = ?:if deed_type = trustees            ; Power of sale foreclosure
foreclosure_date = date:if power_of_sale = true      ; Foreclosure sale date
default_amount = #$:(0..):if power_of_sale = true    ; Default amount

{@deed}

; Executor's/Administrator's Deed
{.estate_deed}
decedent_name = ::if deed_type = executors | deed_type = personal_representative
date_of_death = date:if deed_type = executors | deed_type = personal_representative
probate_case_number = ::if deed_type = executors | deed_type = personal_representative
court_name = ::if deed_type = executors | deed_type = personal_representative
letters_issued = date:if deed_type = executors | deed_type = personal_representative

{@deed}

; Sheriff's/Tax Deed
{.forced_sale_deed}
sale_type = (foreclosure, judgment, tax_sale):if deed_type = sheriffs | deed_type = tax
case_number = ::if deed_type = sheriffs | deed_type = tax
court_name = ::if deed_type = sheriffs               ; Court name
sale_date = date:if deed_type = sheriffs | deed_type = tax
redemption_period_expired = ?:if deed_type = sheriffs | deed_type = tax
certificate_number = ::if deed_type = tax            ; Tax certificate number

{@deed}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (draft, executed, recorded, rejected, void)
status_date = date                                   ; Status date
void_reason = ::if status = void                     ; Reason voided

; ═══════════════════════════════════════════════════════════════════════════════
; DEED RECORDING
; ═══════════════════════════════════════════════════════════════════════════════
; Recording information for deeds and other documents

{@deed_recording}
; Required fields first
recording_date = !date                               ; Date recorded
recording_jurisdiction = !:                          ; Recording jurisdiction

; Recording identification
recording_number = :                                 ; Document/instrument number
book = :                                             ; Record book
page = :                                             ; Page number
reception_number = :                                 ; Reception number

; ───────────────────────────────────────────────────────────────────────────────
; Recording Office
; ───────────────────────────────────────────────────────────────────────────────
{.office}
office_name = :                                      ; Recorder's office name
county = :                                           ; County
state = :(2)                                         ; State
address = @address                                   ; Office address
phone = @phone                                       ; Office phone

{@deed_recording}

; ───────────────────────────────────────────────────────────────────────────────
; Document Details
; ───────────────────────────────────────────────────────────────────────────────
{.document}
document_type = (affidavit, assignment, deed, deed_of_trust, easement, lien, modification, mortgage, notice, partial_release, reconveyance, release, subordination, ucc)
page_count = ##:(1..)                                ; Number of pages
legal_size = ?                                       ; Legal size paper
consideration_shown = #$:(0..)                       ; Consideration on doc
transfer_tax_shown = #$:(0..)                        ; Transfer tax on doc

{@deed_recording}

; ───────────────────────────────────────────────────────────────────────────────
; Recording Method
; ───────────────────────────────────────────────────────────────────────────────
{.method}
recording_type = (electronic, in_person, mail)       ; How recorded
erecording_vendor = ::if recording_type = electronic ; eRecording vendor
submission_date = date                               ; Date submitted
confirmation_number = :                              ; Confirmation number
submitted_by = :                                     ; Submitted by

{@deed_recording}

; ───────────────────────────────────────────────────────────────────────────────
; Fees
; ───────────────────────────────────────────────────────────────────────────────
{.fees}
recording_fee = #$:(0..)                             ; Base recording fee
additional_page_fee = #$:(0..)                       ; Additional page fees
document_fee = #$:(0..)                              ; Document preparation fee
technology_fee = #$:(0..)                            ; Technology/automation fee
tax_fee = #$:(0..)                                   ; Tax-related fee
total_fees = #$:(0..)                                ; Total fees paid

{@deed_recording}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (indexed, pending, recorded, rejected, returned)
status_date = date                                   ; Status date
rejection_reason = ::if status = rejected            ; Rejection reason
rejection_code = ::if status = rejected              ; Rejection code
cure_instructions = ::if status = rejected           ; How to cure

; ═══════════════════════════════════════════════════════════════════════════════
; DEED OF TRUST / MORTGAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Security instrument recording

{@security_instrument}
; Required fields first
execution_date = !date                               ; Date executed
instrument_type = !(deed_of_trust, mortgage, security_deed)
principal_amount = !#$:(0..)                         ; Loan principal
property_address = !@address                         ; Property address

; Instrument identification
instrument_id = :                                    ; Unique identifier
loan_number = :                                      ; Lender loan number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.trustor}
name = :                                             ; Trustor/Mortgagor name
address = @address                                   ; Address

{@security_instrument}

{.beneficiary}
name = :                                             ; Beneficiary/Mortgagee name
mers = ?                                             ; MERS as nominee
mers_min = ::if mers = true                          ; MERS MIN number
address = @address                                   ; Address

{@security_instrument}

{.trustee}
name = ::if instrument_type = deed_of_trust          ; Trustee name
address = @address:if instrument_type = deed_of_trust

{@security_instrument}

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers

{@security_instrument}

; ───────────────────────────────────────────────────────────────────────────────
; Loan Terms
; ───────────────────────────────────────────────────────────────────────────────
{.loan}
principal_amount = #$:(0..)                          ; Original principal
interest_rate = #:(0..100)                           ; Initial interest rate
maturity_date = date                                 ; Maturity date
adjustable_rate = ?                                  ; Is ARM
balloon_payment = ?                                  ; Has balloon
prepayment_penalty = ?                               ; Has prepayment penalty
second_home = ?                                      ; Second home/investment

{@security_instrument}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
recording = @deed_recording                          ; Recording information

; ───────────────────────────────────────────────────────────────────────────────
; Riders
; ───────────────────────────────────────────────────────────────────────────────
{.riders}
adjustable_rate_rider = ?                            ; ARM rider
balloon_rider = ?                                    ; Balloon rider
condo_rider = ?                                      ; Condo rider
pud_rider = ?                                        ; PUD rider
second_home_rider = ?                                ; Second home rider
biweekly_rider = ?                                   ; Biweekly payment rider
other_riders[] = :                                   ; Other riders

{@security_instrument}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, assigned, modified, reconveyed, released, subordinated)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; ASSIGNMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Assignment of mortgage/deed of trust

{@assignment}
; Required fields first
assignment_date = !date                              ; Assignment date
assignee = !:                                        ; New beneficiary
assignor = !:                                        ; Prior beneficiary

; Assignment identification
assignment_id = :                                    ; Unique identifier

; Original instrument reference
{.original_instrument}
type = (deed_of_trust, mortgage)                     ; Instrument type
recording_date = date                                ; Original recording date
recording_number = :                                 ; Document number
book = :                                             ; Book
page = :                                             ; Page
original_amount = #$:(0..)                           ; Original principal
property_address = @address                          ; Property address

{@assignment}

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
{.assignor}
name = :                                             ; Assignor name
mers = ?                                             ; MERS assignment
mers_min = ::if mers = true                          ; MERS MIN
address = @address                                   ; Address

{@assignment}

{.assignee}
name = :                                             ; Assignee name
mers = ?                                             ; MERS as nominee
mers_min = ::if mers = true                          ; MERS MIN
address = @address                                   ; Address

{@assignment}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
recording = @deed_recording                          ; Recording information

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (pending, recorded, rejected)
status_date = date                                   ; Status date


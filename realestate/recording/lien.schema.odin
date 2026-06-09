; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Lien Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property liens and encumbrances including mechanic's, judgment, tax, HOA,
; child support, utility, and UCC fixture filings. Covers lien priority,
; enforcement, payoff, and release/satisfaction recording.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.recording.lien"
version = "1.0.0"
title = "Real Estate Lien Schema"
description = "Property liens and encumbrance tracking"

{$derivation}
source[0].authority = "Uniform Commercial Code"
source[0].citation = "UCC Article 9 - Secured Transactions"
source[0].url = "https://www.uniformlaws.org/acts/ucc"

source[1].authority = "Internal Revenue Service"
source[1].citation = "Federal Tax Lien Procedures"
source[1].url = "https://www.irs.gov/businesses/small-businesses-self-employed/understanding-a-federal-tax-lien"

source[2].authority = "State Mechanics Lien Statutes"
source[2].citation = "Construction Lien Laws"
source[2].url = "https://www.law.cornell.edu/wex/mechanic%27s_lien"

source[3].authority = "American Land Title Association"
source[3].citation = "Lien Priority and Title Examination"
source[3].url = "https://www.alta.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Lien schema derived from UCC and state lien statutes"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial lien schema"
changelog[0].rationale = "Comprehensive lien and encumbrance structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LIEN
; ═══════════════════════════════════════════════════════════════════════════════
; Property lien

{@lien}
; Required fields first
lien_amount = #$:(0..)                              ; Original lien amount
lien_date = date                                    ; Date lien arose
lien_type = (attachment, child_support, condominium, federal_tax, hoa, judgment, mechanics, municipal, state_tax, ucc_fixture, utility)
property_address = @address                         ; Property address

; Lien identification
lien_id = :                                          ; Unique lien identifier
document_number = :                                  ; Recording document number

; ───────────────────────────────────────────────────────────────────────────────
; Lienholder
; ───────────────────────────────────────────────────────────────────────────────
{.lienholder}
name = :                                             ; Lienholder name
entity_type = (agency, association, contractor, government, individual, other, utility)
address = @address                                   ; Lienholder address
phone = @phone                                       ; Phone
email = @email                                       ; Email
contact_name = :                                     ; Contact person

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Debtor
; ───────────────────────────────────────────────────────────────────────────────
{.debtor}
name = :                                             ; Debtor name
entity_type = (corporation, individual, llc, partnership, trust)
address = @address                                   ; Debtor address
property_owner = ?                                   ; Debtor is property owner

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Lien Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
original_amount = #$:(0..)                           ; Original lien amount
accrued_interest = #$:(0..)                          ; Accrued interest
penalties = #$:(0..)                                 ; Penalties/costs
current_balance = #$:(0..)                           ; Current total due
interest_rate = #:(0..100)                           ; Interest rate
priority = (first, junior, pari_passu, second, subordinate, super)
voluntary = ?                                        ; Voluntary lien

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Lien is recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county
state = :(2):if recorded = true                      ; Recording state

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Expiration
; ───────────────────────────────────────────────────────────────────────────────
{.expiration}
expires = ?                                          ; Lien has expiration
expiration_date = date:if expires = true             ; Expiration date
renewable = ?:if expires = true                      ; Can be renewed
renewal_deadline = date:if renewable = true          ; Renewal deadline
extended = ?:if expires = true                       ; Has been extended
extension_date = date:if extended = true             ; Extended until

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Mechanics Lien Specific
; ───────────────────────────────────────────────────────────────────────────────
{.mechanics}
claimant_type = (architect, contractor, design_professional, equipment_lessor, laborer, materialman, subcontractor):if lien_type = mechanics
work_description = ::if lien_type = mechanics        ; Description of work
first_work_date = date:if lien_type = mechanics      ; Date work began
last_work_date = date:if lien_type = mechanics       ; Date work completed
contract_amount = #$:(0..):if lien_type = mechanics  ; Contract amount
amount_paid = #$:(0..):if lien_type = mechanics      ; Amount paid
amount_claimed = #$:(0..):if lien_type = mechanics   ; Lien amount claimed
preliminary_notice = ?:if lien_type = mechanics      ; Prelim notice sent
preliminary_notice_date = date:if preliminary_notice = true
notice_of_completion = ?:if lien_type = mechanics    ; NOC recorded
noc_date = date:if notice_of_completion = true       ; NOC date
filing_deadline = date:if lien_type = mechanics      ; Lien filing deadline
foreclosure_deadline = date:if lien_type = mechanics ; Foreclosure deadline

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Judgment Lien Specific
; ───────────────────────────────────────────────────────────────────────────────
{.judgment}
court_name = ::if lien_type = judgment               ; Court name
case_number = ::if lien_type = judgment              ; Case number
judgment_date = date:if lien_type = judgment         ; Date of judgment
judgment_amount = #$:(0..):if lien_type = judgment   ; Judgment amount
judgment_creditor = ::if lien_type = judgment        ; Judgment creditor
judgment_debtor = ::if lien_type = judgment          ; Judgment debtor
abstract_recorded = ?:if lien_type = judgment        ; Abstract recorded
abstract_date = date:if abstract_recorded = true     ; Abstract date
domesticated = ?:if lien_type = judgment             ; Foreign judgment domesticated
original_state = :(2):if domesticated = true         ; Original judgment state

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Tax Lien Specific
; ───────────────────────────────────────────────────────────────────────────────
{.tax}
taxing_authority = ::if lien_type = federal_tax | lien_type = state_tax
tax_type = (estate, gift, income, property, sales, withholding):if lien_type = federal_tax | lien_type = state_tax
tax_periods = ::if lien_type = federal_tax | lien_type = state_tax
assessment_date = date:if lien_type = federal_tax | lien_type = state_tax
notice_date = date:if lien_type = federal_tax        ; Notice of Federal Tax Lien date
serial_number = ::if lien_type = federal_tax         ; NFTL serial number
collection_statute_date = date:if lien_type = federal_tax ; CSED

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; HOA/Condo Lien Specific
; ───────────────────────────────────────────────────────────────────────────────
{.hoa}
association_name = ::if lien_type = hoa | lien_type = condominium
assessment_type = (regular, special):if lien_type = hoa | lien_type = condominium
delinquent_period = ::if lien_type = hoa | lien_type = condominium
assessments_due = #$:(0..):if lien_type = hoa | lien_type = condominium
late_fees = #$:(0..):if lien_type = hoa | lien_type = condominium
collection_costs = #$:(0..):if lien_type = hoa | lien_type = condominium
attorney_fees = #$:(0..):if lien_type = hoa | lien_type = condominium
super_lien = ?:if lien_type = hoa | lien_type = condominium
super_lien_amount = #$:(0..):if super_lien = true

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; UCC Fixture Filing Specific
; ───────────────────────────────────────────────────────────────────────────────
{.ucc}
filing_number = ::if lien_type = ucc_fixture         ; UCC filing number
filing_date = date:if lien_type = ucc_fixture        ; Filing date
filing_office = ::if lien_type = ucc_fixture         ; Filing office
secured_party = ::if lien_type = ucc_fixture         ; Secured party
collateral_description = ::if lien_type = ucc_fixture ; Collateral
continuation_filed = ?:if lien_type = ucc_fixture    ; Continuation filed
continuation_date = date:if continuation_filed = true
termination_date = date:if lien_type = ucc_fixture   ; Termination date

{@lien}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, contested, expired, foreclosed, partial_release, released, subordinated)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; LIEN RELEASE
; ═══════════════════════════════════════════════════════════════════════════════
; Release/satisfaction of lien

{@lien_release}
; Required fields first
release_date = date                                 ; Release date
release_type = (full, partial, subordination)       ; Type of release

; Release identification
release_id = :                                       ; Unique release identifier
document_number = :                                  ; Recording document number

; Lien reference
lien_ref = @lien                                     ; Reference to original lien

; ───────────────────────────────────────────────────────────────────────────────
; Original Lien Information
; ───────────────────────────────────────────────────────────────────────────────
{.original_lien}
lien_type = (attachment, child_support, federal_tax, hoa, judgment, mechanics, mortgage, state_tax, ucc_fixture, utility)
recording_date = date                                ; Original recording date
recording_number = :                                 ; Original document number
book = :                                             ; Book
page = :                                             ; Page
original_amount = #$:(0..)                           ; Original amount
property_address = @address                          ; Property address

{@lien_release}

; ───────────────────────────────────────────────────────────────────────────────
; Release Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
amount_paid = #$:(0..):if release_type = full | release_type = partial
amount_remaining = #$:(0..):if release_type = partial
consideration = :                                    ; Release consideration
released_by = :                                      ; Releasing party
released_by_title = :                                ; Title of signer
property_released = ::if release_type = partial      ; Property released (partial)

{@lien_release}

; ───────────────────────────────────────────────────────────────────────────────
; Subordination (if subordination agreement)
; ───────────────────────────────────────────────────────────────────────────────
{.subordination}
subordinated_to = ::if release_type = subordination  ; Senior lien description
senior_amount = #$:(0..):if release_type = subordination
senior_holder = ::if release_type = subordination    ; Senior lienholder
subordination_conditions = ::if release_type = subordination

{@lien_release}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Release recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county
state = :(2):if recorded = true                      ; Recording state
recording_fee = #$:(0..):if recorded = true          ; Recording fee

{@lien_release}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (executed, pending, recorded, rejected)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; LIS PENDENS
; ═══════════════════════════════════════════════════════════════════════════════
; Notice of pending litigation

{@lis_pendens}
; Required fields first
filing_date = date                                  ; Date filed
property_address = @address                         ; Property address

; Lis pendens identification
lp_id = :                                            ; Unique identifier
document_number = :                                  ; Recording document number

; ───────────────────────────────────────────────────────────────────────────────
; Litigation Information
; ───────────────────────────────────────────────────────────────────────────────
{.litigation}
court_name = :                                       ; Court name
case_number = :                                      ; Case number
case_type = (boundary, contract, divorce, easement, foreclosure, mechanic_lien, partition, quiet_title, specific_performance)
plaintiff = :                                        ; Plaintiff name
defendant = :                                        ; Defendant name
filing_attorney = :                                  ; Attorney name
attorney_bar_number = :                              ; Attorney bar number
nature_of_action = :                                 ; Description of action

{@lis_pendens}

; ───────────────────────────────────────────────────────────────────────────────
; Property
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers

{@lis_pendens}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recording_date = date                                ; Recording date
recording_number = :                                 ; Document number
book = :                                             ; Book
page = :                                             ; Page
county = :                                           ; Recording county
state = :(2)                                         ; Recording state

{@lis_pendens}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, dismissed, expunged, released, settled)
status_date = date                                   ; Status date
resolution_date = date:if status = dismissed | status = settled
resolution_type = ::if status = dismissed | status = settled


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Title Search Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Title search and examination for real estate transactions including full,
; current owner, bring-down/update, two-owner, and judgment/lien searches.
; Covers chain of title, name searches, title plant data, and examination
; findings with defect identification.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.title.search"
version = "1.0.0"
title = "Title Search Schema"
description = "Title search and examination"

{$derivation}
source[0].authority = "American Land Title Association"
source[0].citation = "Title Examination Standards"
source[0].url = "https://www.alta.org/"

source[1].authority = "State Bar Title Standards"
source[1].citation = "Title Examination Standards"
source[1].url = "https://www.law.cornell.edu/wex/title_search"

source[2].authority = "County Recorder Offices"
source[2].citation = "Recording and Indexing Standards"
source[2].url = "https://www.law.cornell.edu/wex/recording_acts"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Title search schema derived from ALTA and state bar title standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial title search schema"
changelog[0].rationale = "Comprehensive title search structure"

; ═══════════════════════════════════════════════════════════════════════════════
; TITLE SEARCH
; ═══════════════════════════════════════════════════════════════════════════════
; Title search/examination

{@title_search}
; Required fields first
effective_date = date                               ; Search effective date
property_address = @address                         ; Property address
search_type = (bring_down, current_owner, full, judgment_lien, two_owner)

; Search identification
search_id = :                                        ; Unique search identifier
file_number = :                                      ; Title file number
order_number = :                                     ; Search order number

; ───────────────────────────────────────────────────────────────────────────────
; Order Information
; ───────────────────────────────────────────────────────────────────────────────
{.order}
ordered_by = :                                       ; Ordering party
ordered_date = date                                  ; Order date
due_date = date                                      ; Due date
rush = ?                                             ; Rush order
client_name = :                                      ; Client name
client_reference = :                                 ; Client reference number
transaction_type = (construction, purchase, refinance, sale)

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Property Information
; ───────────────────────────────────────────────────────────────────────────────
{.property}
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers
current_owner = :                                    ; Current owner of record
vesting = :                                          ; Vesting description
property_type = (commercial, condominium, land, manufactured, multi_family, pud, residential)

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Search Parameters
; ───────────────────────────────────────────────────────────────────────────────
{.parameters}
search_period_years = ##:(1..)                       ; Years to search
start_date = date                                    ; Search start date
end_date = date                                      ; Search end date
prior_search_date = date:if search_type = bring_down ; Prior search date
include_judgment_search = ?                          ; Include judgment search
judgment_names[] = :                                 ; Names for judgment search
include_tax_search = ?                               ; Include tax search
include_assessment_search = ?                        ; Include special assessments

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Search Sources
; ───────────────────────────────────────────────────────────────────────────────
{.sources}
recorder_office = :                                  ; Recorder office searched
court_records = ?                                    ; Court records searched
tax_office = ?                                       ; Tax records searched
assessor_office = ?                                  ; Assessor records searched
federal_court = ?                                    ; Federal court searched
state_court = ?                                      ; State court searched
ucc_records = ?                                      ; UCC records searched
title_plant = ?                                      ; Title plant used
title_plant_name = ::if title_plant = true           ; Title plant name
online_search = ?                                    ; Online records search

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Chain of Title
; ───────────────────────────────────────────────────────────────────────────────
{.chain[]}
document_type = (assignment, contract_for_deed, court_order, deed, partition, probate, special_warranty, trustees_deed, warranty_deed)
grantor = :                                          ; Grantor name
grantee = :                                          ; Grantee name
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
consideration = #$:(0..)                             ; Consideration
vesting_type = :                                     ; Vesting type
issues[] = :                                         ; Issues identified

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Mortgages/Deeds of Trust
; ───────────────────────────────────────────────────────────────────────────────
{.mortgages[]}
document_type = (deed_of_trust, mortgage, security_deed)
mortgagor = :                                        ; Mortgagor name
mortgagee = :                                        ; Mortgagee/lender name
original_amount = #$:(0..)                           ; Original amount
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
maturity_date = date                                 ; Maturity date
assigned = ?                                         ; Has been assigned
current_holder = ::if assigned = true                ; Current holder
released = ?                                         ; Has been released
release_date = date:if released = true               ; Release date
release_document = ::if released = true              ; Release document number

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Liens and Encumbrances
; ───────────────────────────────────────────────────────────────────────────────
{.liens[]}
lien_type = (child_support, federal_tax, hoa, judgment, mechanics, state_tax, ucc, utility)
lienholder = :                                       ; Lienholder name
debtor = :                                           ; Debtor name
amount = #$:(0..)                                    ; Lien amount
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
expiration_date = date                               ; Expiration date (if applicable)
released = ?                                         ; Has been released
release_date = date:if released = true               ; Release date
status = (active, expired, released)

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Easements and Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.easements[]}
easement_type = (access, conservation, drainage, pipeline, railroad, utility, view)
holder = :                                           ; Easement holder
purpose = :                                          ; Purpose/use
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
book = :                                             ; Book
page = :                                             ; Page
affects_marketability = ?                            ; Affects marketability
description = :                                      ; Description

{@title_search}

{.restrictions[]}
restriction_type = (architectural, building, historic, subdivision, use)
description = :                                      ; Restriction description
recording_date = date                                ; Recording date
document_number = :                                  ; Document number
expiration_date = date                               ; Expiration date
enforced_by = :                                      ; Enforcing party

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Tax Information
; ───────────────────────────────────────────────────────────────────────────────
{.taxes}
tax_id = *:                                           ; Tax parcel ID
tax_year = ##:(1900..2100)                           ; Current tax year
assessed_value = #$:(0..)                            ; Assessed value
annual_taxes = #$:(0..)                              ; Annual taxes
current_year_paid = ?                                ; Current year paid
delinquent_years[] = ##:(1900..2100)                 ; Delinquent years
delinquent_amount = #$:(0..)                         ; Total delinquent
special_assessments = #$:(0..)                       ; Special assessments
tax_sale_pending = ?                                 ; Tax sale pending
redemption_date = date:if tax_sale_pending = true    ; Redemption deadline

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Judgment Search
; ───────────────────────────────────────────────────────────────────────────────
{.judgments[]}
debtor_name = :                                      ; Debtor name searched
creditor = :                                         ; Creditor name
court = :                                            ; Court name
case_number = :                                      ; Case number
judgment_date = date                                 ; Judgment date
amount = #$:(0..)                                    ; Judgment amount
abstract_recorded = ?                                ; Abstract recorded
abstract_date = date:if abstract_recorded = true     ; Abstract recording date
satisfied = ?                                        ; Judgment satisfied
satisfaction_date = date:if satisfied = true         ; Satisfaction date

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Issues Identified
; ───────────────────────────────────────────────────────────────────────────────
{.issues[]}
issue_type = (break_in_chain, gap, legal_description, lien, name_variance, open_mortgage, pending_action, unreleased_document, vesting)
severity = (critical, informational, major, minor)
description = :                                      ; Issue description
curative_action = :                                  ; Required curative action
document_reference = :                               ; Related document reference
resolved = ?                                         ; Issue resolved
resolution = ::if resolved = true                    ; How resolved

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Examiner Information
; ───────────────────────────────────────────────────────────────────────────────
{.examiner}
examiner_name = :                                    ; Examiner name
examiner_id = :                                      ; Examiner ID
abstractor_name = :                                  ; Abstractor name
examination_date = date                              ; Examination date
review_date = date                                   ; Review date
reviewed_by = :                                      ; Reviewer name

{@title_search}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, in_progress, ordered, pending_review)
status_date = date                                   ; Status date
completion_date = date:if status = completed         ; Completion date

; ═══════════════════════════════════════════════════════════════════════════════
; NAME SEARCH
; ═══════════════════════════════════════════════════════════════════════════════
; Judgment and lien search by name

{@name_search}
; Required fields first
search_date = date                                  ; Search date
search_name = :                                     ; Name searched

; Search identification
search_id = :                                        ; Unique search identifier

; ───────────────────────────────────────────────────────────────────────────────
; Search Parameters
; ───────────────────────────────────────────────────────────────────────────────
{.parameters}
name_type = (business, individual)                   ; Name type
aliases[] = :                                        ; Aliases/variations searched
ssn_last_four = *:(4):if name_type = individual      ; Last 4 SSN (confidential)
ein_last_four = *:(4):if name_type = business        ; Last 4 EIN (confidential)
county = :                                           ; County searched
state = :(2)                                         ; State searched
federal = ?                                          ; Federal search included
period_years = ##:(1..30)                            ; Search period

{@name_search}

; ───────────────────────────────────────────────────────────────────────────────
; Results
; ───────────────────────────────────────────────────────────────────────────────
{.results}
clear = ?                                            ; Search came back clear
items_found = ##:(0..)                               ; Number of items found

{@name_search}

; Found items
{.results.items[]}
item_type = (bankruptcy, child_support, federal_tax_lien, judgment, state_tax_lien, ucc)
debtor_name = :                                      ; Debtor name as indexed
creditor = :                                         ; Creditor name
case_number = :                                      ; Case/filing number
filing_date = date                                   ; Filing date
amount = #$:(0..)                                    ; Amount
status = (active, discharged, released, satisfied)
matches_subject = ?                                  ; Matches search subject
match_confidence = (definite, possible, unlikely)

{@name_search}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (completed, ordered, pending)
status_date = date                                   ; Status date


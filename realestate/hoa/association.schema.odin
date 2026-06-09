; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Homeowners Association Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Community association management for HOAs, condominiums, cooperatives, PUDs,
; and master/sub-associations. Covers governance, financials, insurance,
; litigation, common areas, board members, and individual unit tracking
; including assessments, violations, and architectural requests.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.hoa.association"
version = "1.0.0"
title = "Homeowners Association Schema"
description = "HOA, condominium, and community association management"

{$derivation}
source[0].authority = "Community Associations Institute"
source[0].citation = "Community Association Factbook"
source[0].url = "https://www.caionline.org/"

source[1].authority = "Uniform Common Interest Ownership Act"
source[1].citation = "UCIOA"
source[1].url = "https://www.uniformlaws.org/committees/community-home?CommunityKey=ef72ca94-6040-4dd4-a4ea-3ac73cfa4e62"

source[2].authority = "State Condominium Acts"
source[2].citation = "State HOA/Condo Statutes"
source[2].url = "https://www.law.cornell.edu/wex/condominium"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Association schema derived from CAI standards and state HOA laws"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial association schema"
changelog[0].rationale = "Comprehensive HOA/condo association structure"

; ═══════════════════════════════════════════════════════════════════════════════
; ASSOCIATION
; ═══════════════════════════════════════════════════════════════════════════════
; Community association entity

{@association}
; Required fields first
association_name = :                                ; Legal name of association
association_type = (condominium, cooperative, hoa, master, poa, pud, sub_association, townhouse)
state = :(2)                                        ; State of organization

; Association identification
association_id = :                                   ; Unique association identifier
tax_id = *:                                          ; Federal tax ID (confidential)
state_id = :                                         ; State registration number

; ───────────────────────────────────────────────────────────────────────────────
; Registration
; ───────────────────────────────────────────────────────────────────────────────
{.registration}
incorporation_state = :(2)                           ; State of incorporation
incorporation_date = date                            ; Date incorporated
entity_type = (corporation, nonprofit, trust, unincorporated)
registered_agent = :                                 ; Registered agent name
registered_agent_address = @address                  ; Agent address
annual_report_due = date                             ; Annual report due date

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
mailing_address = @address                           ; Association mailing address
physical_address = @address                          ; Physical address (if different)
phone = @phone                                       ; Main phone
fax = @phone                                         ; Fax number
email = @email                                       ; General email
website = :                                          ; Website URL
office_hours = :                                     ; Office hours

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Management
; ───────────────────────────────────────────────────────────────────────────────
{.management}
self_managed = ?                                     ; Self-managed (no management company)
management_company = ::if self_managed = false       ; Management company name
manager_name = :                                     ; Property manager name
manager_phone = @phone                               ; Manager phone
manager_email = @email                               ; Manager email
management_address = @address:if self_managed = false
management_contract_start = date:if self_managed = false
management_contract_end = date:if self_managed = false
management_fee_monthly = #$:(0..):if self_managed = false

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Community Details
; ───────────────────────────────────────────────────────────────────────────────
{.community}
community_name = :                                   ; Community/subdivision name
city = :                                             ; City
county = :                                           ; County
developer_name = :                                   ; Original developer
development_date = date                              ; Development start date
total_units = ##:(1..)                               ; Total units
total_lots = ##:(0..)                                ; Total lots (if applicable)
phases = ##:(1..)                                    ; Number of phases
phases_complete = ##:(0..)                           ; Phases complete
declarant_control = ?                                ; Declarant still in control
declarant_control_ends = date:if declarant_control = true

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Governance
; ───────────────────────────────────────────────────────────────────────────────
{.governance}
fiscal_year_end = :                                  ; Fiscal year end (MM-DD)
annual_meeting_month = ##:(1..12)                    ; Annual meeting month
quorum_percentage = #:(0..100)                       ; Quorum requirement
board_term_years = ##:(1..5)                         ; Board term length
staggered_terms = ?                                  ; Staggered board terms
voting_method = (cumulative, in_person, mail, online, proxy)
one_vote_per_unit = ?                                ; One vote per unit
percentage_vote = ?:if one_vote_per_unit = false     ; Percentage interest voting

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Common Areas
; ───────────────────────────────────────────────────────────────────────────────
{.common_areas}
pool = ?                                             ; Community pool
clubhouse = ?                                        ; Clubhouse
fitness_center = ?                                   ; Fitness center
tennis_courts = ##:(0..)                             ; Tennis court count
playground = ?                                       ; Playground
common_grounds_acres = #:(0..)                       ; Common grounds acreage
private_streets = ?                                  ; Private streets
gated = ?                                            ; Gated community
security = ?                                         ; Security patrol
lake_pond = ?                                        ; Lake or pond
golf_course = ?                                      ; Golf course
other_amenities[] = :                                ; Other amenities

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
master_policy = ?                                    ; Has master insurance policy
master_carrier = ::if master_policy = true           ; Insurance carrier
master_policy_number = ::if master_policy = true     ; Policy number
property_coverage = #$:(0..):if master_policy = true ; Property coverage
liability_coverage = #$:(0..):if master_policy = true ; Liability coverage
directors_officers = ?                               ; D&O insurance
fidelity_bond = ?                                    ; Fidelity bond
fidelity_amount = #$:(0..):if fidelity_bond = true   ; Bond amount
umbrella_coverage = #$:(0..)                         ; Umbrella coverage
workers_comp = ?                                     ; Workers compensation

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Summary
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
operating_budget = #$:(0..)                          ; Annual operating budget
reserve_balance = #$:(0..)                           ; Current reserve balance
reserve_study_date = date                            ; Last reserve study
reserve_fully_funded = ?                             ; Reserves fully funded
funded_percentage = #:(0..100)                       ; Reserve funding percentage
special_assessment_pending = ?                       ; Special assessment pending
special_assessment_amount = #$:(0..):if special_assessment_pending = true
delinquency_rate = #:(0..100)                        ; Delinquency percentage
bank_name = :                                        ; Primary bank
bank_account = *:                                    ; Account number (confidential)

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Litigation
; ───────────────────────────────────────────────────────────────────────────────
{.litigation}
pending_litigation = ?                               ; Pending litigation
litigation_count = ##:(0..):if pending_litigation = true
significant_claims = ?                               ; Significant claims pending
claim_description = ::if significant_claims = true   ; Description
construction_defect = ?                              ; Construction defect claim
defect_status = ::if construction_defect = true      ; Defect claim status

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Master/Sub Association
; ───────────────────────────────────────────────────────────────────────────────
{.hierarchy}
master_association = ?                               ; Is master association
sub_associations[] = ::if master_association = true  ; Sub-association names
belongs_to_master = ?                                ; Belongs to master
master_association_name = ::if belongs_to_master = true
master_dues = #$:(0..):if belongs_to_master = true   ; Master association dues

{@association}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, dissolved, dormant, under_declarant_control)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; BOARD MEMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Association board member

{@board_member}
= @person                                            ; Inherits person base

; Board member identification
member_id = :                                        ; Unique member identifier

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Position
; ───────────────────────────────────────────────────────────────────────────────
{.position}
title = (director, president, secretary, treasurer, vice_president)
term_start = date                                    ; Term start date
term_end = date                                      ; Term end date
elected_date = date                                  ; Election date
appointed = ?                                        ; Appointed vs. elected

{@board_member}

; ───────────────────────────────────────────────────────────────────────────────
; Contact
; ───────────────────────────────────────────────────────────────────────────────
unit_number = :                                      ; Unit/lot owned
unit_address = @address                              ; Unit address
phone = @phone                                       ; Phone
email = @email                                       ; Email

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, former, resigned)
status_date = date                                   ; Status date
resignation_date = date:if status = resigned         ; Resignation date

; ═══════════════════════════════════════════════════════════════════════════════
; ASSOCIATION UNIT
; ═══════════════════════════════════════════════════════════════════════════════
; Individual unit/lot within association

{@association_unit}
; Required fields first
unit_address = @address                             ; Unit address
unit_number = :                                     ; Unit/lot number

; Unit identification
unit_id = :                                          ; Unique unit identifier
lot_number = :                                       ; Lot number (if applicable)
building_number = :                                  ; Building number (condo)
phase = ##:(1..)                                     ; Development phase

; Association reference
association_ref = @association                       ; Reference to association

; ───────────────────────────────────────────────────────────────────────────────
; Owner Information
; ───────────────────────────────────────────────────────────────────────────────
{.owner}
name = :                                             ; Owner name
mailing_address = @address                           ; Mailing address
phone = @phone                                       ; Phone
email = @email                                       ; Email
owner_occupied = ?                                   ; Owner occupied
purchase_date = date                                 ; Purchase date
rental_registered = ?                                ; Rental registration
tenant_name = ::if rental_registered = true          ; Tenant name
tenant_phone = @phone:if rental_registered = true    ; Tenant phone

{@association_unit}

; Co-owners
{.owner.co_owners[]}
name = :                                             ; Co-owner name
phone = @phone                                       ; Phone
email = @email                                       ; Email

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Unit Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
unit_type = (condo, lot, townhouse)                  ; Unit type
sqft = ##:(0..)                                      ; Square footage
bedrooms = ##:(0..)                                  ; Bedrooms
bathrooms = #:(0..)                                  ; Bathrooms
parking_spaces = ##:(0..)                            ; Parking spaces
garage_spaces = ##:(0..)                             ; Garage spaces
storage_unit = ?                                     ; Has storage unit
storage_number = ::if storage_unit = true            ; Storage unit number
percentage_interest = #:(0..100)                     ; Percentage interest
voting_weight = #:(0..)                              ; Voting weight

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Assessment Information
; ───────────────────────────────────────────────────────────────────────────────
{.assessments}
regular_assessment = #$:(0..)                        ; Regular monthly assessment
special_assessment = #$:(0..)                        ; Current special assessment
assessment_frequency = (annual, monthly, quarterly, semi_annual)
last_increase_date = date                            ; Last assessment increase
next_increase_date = date                            ; Projected next increase
includes_utilities[] = :                             ; Utilities included

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Account Status
; ───────────────────────────────────────────────────────────────────────────────
{.account}
current_balance = #$                                 ; Current balance (can be credit)
past_due_amount = #$:(0..)                           ; Past due amount
months_delinquent = ##:(0..)                         ; Months delinquent
last_payment_date = date                             ; Last payment date
last_payment_amount = #$:(0..)                       ; Last payment amount
payment_plan = ?                                     ; On payment plan
lien_filed = ?                                       ; Lien filed
lien_amount = #$:(0..):if lien_filed = true          ; Lien amount
collection_referred = ?                              ; Sent to collection

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Violations
; ───────────────────────────────────────────────────────────────────────────────
{.violations[]}
violation_date = date                                ; Violation date
violation_type = (architectural, landscaping, noise, parking, pet, rental, trash)
description = :                                      ; Violation description
notice_sent = date                                   ; Notice date
hearing_date = date                                  ; Hearing date (if applicable)
fine_assessed = #$:(0..)                             ; Fine amount
fine_paid = ?                                        ; Fine paid
resolved = ?                                         ; Violation resolved
resolution_date = date:if resolved = true            ; Resolution date

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Architectural Requests
; ───────────────────────────────────────────────────────────────────────────────
{.architectural_requests[]}
request_date = date                                  ; Request date
request_type = :                                     ; Type of request
description = :                                      ; Description of work
status = (approved, denied, pending, withdrawn)
decision_date = date:if status = approved | status = denied
conditions = ::if status = approved                  ; Approval conditions
denial_reason = ::if status = denied                 ; Denial reason
completion_deadline = date:if status = approved      ; Work completion deadline
completed = ?:if status = approved                   ; Work completed

{@association_unit}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, delinquent, foreclosure, good_standing)
status_date = date                                   ; Status date


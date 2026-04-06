; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Surety Bond Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Surety bond schema for contract surety (bid, performance, payment, maintenance
; bonds), commercial surety (license/permit, court, public official, fidelity
; bonds), and federal bonds (Miller Act, customs, immigration).
; ═══════════════════════════════════════════════════════════════════════════════

@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.surety"
version = "1.0.0"
title = "Surety Bond Schema"
description = "Comprehensive surety bond schema for contract and commercial surety"

{$derivation}
source[0].authority = "U.S. Small Business Administration"
source[0].citation = "Surety Bond Guarantee Program"
source[0].url = "https://www.sba.gov/funding-programs/surety-bonds"

source[1].authority = "Federal Acquisition Regulation"
source[1].citation = "FAR Part 28 - Bonds and Insurance"
source[1].url = "https://www.acquisition.gov/far/part-28"

source[2].authority = "Miller Act"
source[2].citation = "40 U.S.C. 3131-3134 - Performance and Payment Bonds"
source[2].url = "https://uscode.house.gov/view.xhtml?path=/prelim@title40/subtitle2/partA/chapter31/subchapter3&edition=prelim"

source[3].authority = "U.S. Customs and Border Protection"
source[3].citation = "19 CFR Part 113 - Customs Bonds"
source[3].url = "https://www.cbp.gov/trade/priority-issues/revenue/bonds"

source[4].authority = "U.S. Department of Treasury"
source[4].citation = "Circular 570 - Treasury's Listing of Certified Companies"
source[4].url = "https://www.fiscal.treasury.gov/surety-bonds/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Surety bond schema based on FAR, Miller Act, and Treasury requirements"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial surety bond schema"
changelog[0].rationale = "Complete surety bond data model for contract and commercial bonds"

; ═══════════════════════════════════════════════════════════════════════════════
; Bond Principal
; ═══════════════════════════════════════════════════════════════════════════════
; The principal IS a business entity with additional financial/bonding info.
; This inheritance is intentional - different from insurance where insured
; is a reference.

{@bond_principal}
id = :                                            ; Unique identifier for bond principal

; Identity - inherits business entity
= @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Principal Financial Information
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
working_capital = #$                              ; Can be negative
net_worth = #$                                    ; Can be negative
current_assets = #$:(0..)
current_liabilities = #$:(0..)
total_assets = #$:(0..)
total_liabilities = #$:(0..)
retained_earnings = #$                            ; Can be negative
cash_on_hand = #$:(0..)
accounts_receivable = #$:(0..)
accounts_payable = #$:(0..)
line_of_credit = #$:(0..)
line_of_credit_available = #$:(0..)

; Financial Statement
fiscal_year_end = date                            ; End date of principal's fiscal year
statement_date = date                             ; Date financial statement was prepared
statement_type = (audited, compiled, cpa_prepared, internal, reviewed)  ; Type of financial statement
accountant_name = :                               ; Name of accountant who prepared statement
accountant_firm = :                               ; Accounting firm name

{@bond_principal}

; ───────────────────────────────────────────────────────────────────────────────
; Bank Information
; ───────────────────────────────────────────────────────────────────────────────
{.bank}
bank_name = :                                     ; Name of financial institution
bank_branch = :                                   ; Branch location or identifier
bank_contact = :                                  ; Primary bank contact name
bank_phone = *@phone                              ; Bank contact phone number
account_number = *:                               ; Bank account number
credit_line = #$:(0..)                            ; Total credit line amount
relationship_years = ##:(0..100)                  ; Years of banking relationship

{@bond_principal}

; ───────────────────────────────────────────────────────────────────────────────
; Bonding History
; ───────────────────────────────────────────────────────────────────────────────
{.bonding_history}
years_bonded = ##:(0..100)                        ; Years principal has been bonded
current_surety = :                                ; Current surety company name
prior_surety = :                                  ; Previous surety company name
reason_for_change = :                             ; Reason for changing surety companies
bond_claims_history = ?                           ; Whether principal has claims history
claims_paid_amount = #$:(0..):if bond_claims_history = true  ; Total amount paid on claims
claims_description = ::if bond_claims_history = true  ; Description of claim circumstances

; Single/Aggregate Program
single_bond_limit = #$:(0..)                      ; Maximum amount for single bond
aggregate_bond_limit = #$:(0..)                   ; Maximum total amount for all bonds
bonds_outstanding_count = ##                      ; Number of currently outstanding bonds
bonds_outstanding_amount = #$:(0..)               ; Total amount of outstanding bonds

{@bond_principal}

; ───────────────────────────────────────────────────────────────────────────────
; Work History (Contract Surety)
; ───────────────────────────────────────────────────────────────────────────────
{.work_history}
largest_job_completed = #$:(0..)                  ; Dollar value of largest completed job
largest_job_description = :                       ; Description of largest job completed
current_backlog = #$:(0..)                        ; Total value of awarded uncompleted work
annual_volume_3yr_avg = #$:(0..)                  ; Three-year average annual revenue
projects_in_progress = ##                         ; Number of current active projects
work_in_progress_value = #$:(0..)                 ; Total value of work in progress

; Experience
years_in_construction = ##:(0..100)               ; Years of experience in construction
types_of_work[] = (bridges, building_commercial, building_industrial, building_institutional, building_residential, dams, demolition, dredging, electrical, environmental, excavation, foundation, general_contracting, heavy_civil, highway, hvac_mechanical, marine, painting, pipeline, plumbing, power_plant, renovation, roofing, site_work, specialty, steel_erection, telecom, underground, utilities, waterworks)  ; Types of construction work performed

{@bond_principal}

; ───────────────────────────────────────────────────────────────────────────────
; Indemnitors
; ───────────────────────────────────────────────────────────────────────────────
{@bond_principal.indemnitors[]}
id = :                                            ; Unique identifier for indemnitor
type = (corporate, individual)                    ; Type of indemnitor

; Individual Indemnitor
name = :                                          ; Full legal name of indemnitor
relationship = (officer, owner, spouse)           ; Relationship to principal
ownership_percentage = ##:(0..100)                ; Percentage ownership in principal
ssn = *:                                          ; Social security number (confidential)
date_of_birth = *date                             ; Date of birth (confidential)
net_worth = #$:(0..)                              ; Personal net worth
liquid_assets = #$:(0..)                          ; Liquid assets available

; Address
address = @address                                ; Indemnitor's address

{@bond_principal}

; ═══════════════════════════════════════════════════════════════════════════════
; Bond Obligee
; ═══════════════════════════════════════════════════════════════════════════════

{@bond_obligee}
id = :                                            ; Unique identifier for bond obligee

; Identity
legal_name = :                                    ; Legal name of obligee organization
contact_name = :                                  ; Primary contact person name
contact_title = :                                 ; Title of primary contact
phone = *@phone                                   ; Contact phone number (confidential)
email = *@email                                   ; Contact email address (confidential)

; Address
address = @address                                ; Obligee's address

; ───────────────────────────────────────────────────────────────────────────────
; Obligee Type
; ───────────────────────────────────────────────────────────────────────────────
obligee_type = (
    contractor_prime,
    federal_agency,
    financial_institution,
    government_entity,
    municipality,
    other,
    owner_developer,
    private_entity,
    public_utility,
    school_district,
    state_agency,
    transportation_authority
)                                                 ; Type of obligee organization

; Federal Agency Details
federal_agency_code = ::if obligee_type = federal_agency  ; Federal agency code
federal_duns = :(9):if obligee_type = federal_agency      ; DUNS number (9 digits)
federal_cage = :(5):if obligee_type = federal_agency      ; CAGE code (5 digits)

; ═══════════════════════════════════════════════════════════════════════════════
; Contract Information (for Contract Surety)
; ═══════════════════════════════════════════════════════════════════════════════

{@bond_contract}
id = :                                            ; Unique identifier for bond contract

; ───────────────────────────────────────────────────────────────────────────────
; Contract Details
; ───────────────────────────────────────────────────────────────────────────────
number = :                                        ; Contract number or identifier
description = :                                   ; Description of contract work
type = (
    cost_plus,
    design_bid_build,
    design_build,
    guaranteed_maximum,
    lump_sum,
    negotiated,
    time_and_materials,
    unit_price
)                                                 ; Type of contract

; Contract Value
contract_amount = #$:(0..)                        ; Original total contract amount
base_contract = #$:(0..)                          ; Base contract amount
alternates = #$:(0..)                             ; Value of alternates included
change_orders = #$                                ; Can be negative
contract_amount_current = #$:(0..)                ; Current contract amount with changes

; ───────────────────────────────────────────────────────────────────────────────
; Schedule
; ───────────────────────────────────────────────────────────────────────────────
notice_to_proceed = date                          ; Date notice to proceed was issued
effective = date                                  ; Contract effective date
substantial_completion = date                     ; Scheduled substantial completion date
final_completion = date                           ; Scheduled final completion date
liquidated_damages = #$:(0..)                     ; Liquidated damages amount
liquidated_damages_per = (day, week)              ; Liquidated damages period

; ───────────────────────────────────────────────────────────────────────────────
; Project Information
; ───────────────────────────────────────────────────────────────────────────────
{.project}
project_name = :                                  ; Name of construction project
project_number = :                                ; Project number or identifier

; Project Location
address = @address                                ; Physical address of project site
county = :                                        ; County where project is located

; Project Details
project_type = (
    airport,
    bridge,
    building,
    dam,
    environmental,
    highway,
    hospital,
    industrial,
    marine,
    park,
    pipeline,
    power,
    rail,
    school,
    sewer_water,
    telecom,
    transit,
    tunnel,
    utility
)                                                 ; Type of construction project

public_private = (private, public, public_private_partnership)  ; Project ownership type
federal_funded = ?                                ; Whether project is federally funded
federal_project_number = ::if federal_funded = true  ; Federal project number
state_funded = ?                                  ; Whether project is state funded
davis_bacon_applicable = ?                        ; Whether Davis-Bacon Act applies
buy_america_applicable = ?                        ; Whether Buy America Act applies

{@bond_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Retainage
; ───────────────────────────────────────────────────────────────────────────────
{.retainage}
percentage = ##:(0..15)                           ; Retainage percentage withheld
amount_withheld = #$:(0..)                        ; Total retainage amount withheld
release_at_substantial = ?                        ; Whether retainage released at substantial completion
release_at_final = ?                              ; Whether retainage released at final completion

{@bond_contract}

; ───────────────────────────────────────────────────────────────────────────────
; Subcontract Information
; ───────────────────────────────────────────────────────────────────────────────
{.subcontract}
subcontracted_percentage = ##:(0..100)            ; Percentage of work to be subcontracted
largest_subcontract = #$:(0..)                    ; Dollar value of largest subcontract
major_subcontractors[] = :                        ; Names of major subcontractors
bonded_subcontractors = ?                         ; Whether subcontractors are bonded

{@bond_contract}

; ═══════════════════════════════════════════════════════════════════════════════
; Surety Bond (Core Type)
; ═══════════════════════════════════════════════════════════════════════════════

{@surety_bond}
id = :                                            ; Unique identifier for surety bond
number = :                                        ; Bond number

; ───────────────────────────────────────────────────────────────────────────────
; Bond Classification
; ───────────────────────────────────────────────────────────────────────────────
category = (
    commercial,
    contract,
    court,
    federal,
    fidelity
)                                                 ; High-level bond category

type = (administrator, ancillary_contract, appeal, attachment, bid, blanket_position, collection, commercial_blanket, completion, conservator, cost, customs, employee_dishonesty, erisa, excise_tax, executor, fiduciary, financial_guarantee, guardian, immigration, injunction, irs, license_permit, lost_instrument, maintenance_warranty, miller_act_payment, miller_act_performance, name_schedule, payment, performance, performance_and_payment, position_schedule, probate, public_official, receiver, reclamation, replevin, sba_guaranteed, self_insurance, subdivision, supply, trustee, utility_deposit, warehouse, workers_comp_self_insurance)  ; Specific bond type

; ───────────────────────────────────────────────────────────────────────────────
; Bond Amount and Term
; ───────────────────────────────────────────────────────────────────────────────
amount = #$:(0..)                                 ; Face amount of bond
amount_increasing = ?                             ; Bond increases with contract changes
estimated_contract_value = #$:(0..):if type = bid  ; Estimated contract value for bid bond

; Bid Bond Specifics
bid_percentage = ##:(5, 10, 15, 20):if type = bid  ; Bid bond percentage of contract value
bid_date = date:if type = bid                     ; Date bid is submitted
bid_valid_days = ##:(0..365):if type = bid        ; Number of days bid remains valid

; Term
effective_date = date                             ; Bond effective date
expiration_date = date                            ; Bond expiration date
continuous_until_cancelled = ?                    ; Whether bond is continuous
term_years = ##:(1..10):if continuous_until_cancelled = false  ; Term in years if not continuous
renewable = ?                                     ; Whether bond is renewable

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
principal = @bond_principal                       ; Principal party (contractor)
obligee = @bond_obligee                           ; Obligee party (project owner)
dual_obligee = @bond_obligee                      ; For dual obligee rider

; Co-Surety (if applicable)
co_surety = ?                                     ; Whether bond has co-surety
co_surety_name = ::if co_surety = true            ; Name of co-surety company
co_surety_percentage = ##:(0..100):if co_surety = true  ; Co-surety percentage share

; ───────────────────────────────────────────────────────────────────────────────
; Contract Reference (Contract Surety)
; ───────────────────────────────────────────────────────────────────────────────
contract = @bond_contract:if category = contract  ; Reference to bonded contract

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
rate_per_thousand = #:(0..100)                    ; Premium rate per thousand dollars
premium_amount = #$:(0..)                         ; Total premium amount
minimum_premium = #$:(0..)                        ; Minimum premium required
commission_percentage = #:(0..50)                 ; Agent commission percentage
sba_guarantee_fee = #$:(0..):if type = sba_guaranteed  ; SBA guarantee fee amount

; Payment
premium_paid = ?                                  ; Whether premium has been paid
premium_paid_date = date:if premium_paid = true   ; Date premium was paid
premium_financed = ?                              ; Whether premium is financed
finance_company = ::if premium_financed = true    ; Finance company name

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Bond Form
; ───────────────────────────────────────────────────────────────────────────────
{.form}
form_number = :                                   ; Bond form number
form_edition = :                                  ; Bond form edition
form_type = (custom, federal_standard, industry_standard, state_required, surety_standard)  ; Type of bond form
special_conditions[] = :                          ; Special conditions attached to bond

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Federal Bond Details
; ───────────────────────────────────────────────────────────────────────────────
{.federal}
miller_act = ?:if category = federal              ; Whether bond is Miller Act bond
federal_contract_number = ::if miller_act = true  ; Federal contract number
contracting_officer = ::if miller_act = true      ; Contracting officer name
sam_registration = ?:if miller_act = true         ; Whether registered in SAM.gov
cage_code = :(5):if miller_act = true             ; CAGE code (5 digits)
duns_number = :(9):if miller_act = true           ; DUNS number (9 digits)

; Customs Bond Specifics
customs_bond_type = (
    activity_code_1_importer,
    activity_code_2_custodian,
    activity_code_3_carrier,
    activity_code_4_foreign_trade_zone,
    continuous_customs,
    single_entry
):if type = customs                               ; Type of customs bond
customs_activity_code = :(2):if type = customs    ; Customs activity code (2 digits)
importer_of_record = ::if type = customs          ; Importer of record name
customs_broker = ::if type = customs              ; Customs broker name

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; License/Permit Bond Details
; ───────────────────────────────────────────────────────────────────────────────
{.license_permit}
license_type = (
    auto_dealer,
    collection_agency,
    contractor,
    freight_broker,
    mortgage_broker,
    notary,
    other,
    professional,
    sales_tax,
    seller_of_travel,
    service_contract_provider,
    telemarketer,
    title_agent
):if type = license_permit                        ; Type of license or permit
license_number = *:if type = license_permit       ; License number (confidential)
licensing_authority = ::if type = license_permit  ; Licensing authority name
state_province = :(2):if type = license_permit    ; State or province code (2 chars)

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Court Bond Details
; ───────────────────────────────────────────────────────────────────────────────
{.court}
court_name = ::if category = court                ; Name of court
court_case_number = ::if category = court         ; Court case number
judge_name = ::if category = court                ; Presiding judge name
matter_name = ::if category = court               ; Name of legal matter
estate_value = #$:(0..):if category = court       ; Value of estate (for fiduciary bonds)
appeal_judgment_amount = #$:(0..):if type = appeal  ; Judgment amount being appealed

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Fidelity Bond Details
; ───────────────────────────────────────────────────────────────────────────────
{.fidelity}
covered_employees = ##:if category = fidelity     ; Number of employees covered
per_loss_limit = #$:(0..):if category = fidelity  ; Per loss coverage limit
aggregate_limit = #$:(0..):if category = fidelity  ; Aggregate coverage limit
deductible = #$:(0..):if category = fidelity      ; Deductible amount
erisa_plan = ?:if type = erisa                    ; Whether covering ERISA plan
erisa_plan_assets = #$:(0..):if erisa_plan = true  ; Value of ERISA plan assets

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Riders and Endorsements
; ───────────────────────────────────────────────────────────────────────────────
{@surety_bond.riders[]}
id = :                                            ; Unique identifier for rider
type = (
    aggregate_penalty,
    amendment,
    cancellation_notice,
    consent_of_surety,
    continuation_certificate,
    decrease,
    dual_obligee,
    increase,
    name_change,
    other,
    reinstatement,
    rider
)                                                 ; Type of rider or endorsement
rider_number = :                                  ; Rider number
effective_date = date                             ; Rider effective date
description = :                                   ; Description of rider changes
amount_change = #$                                ; Can be negative
premium_change = #$                               ; Can be negative

{@surety_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    active,
    cancelled,
    claim_filed,
    claim_paid,
    expired,
    pending,
    released,
    renewed
)                                                 ; Current bond status

cancellation_date = date:if status = cancelled    ; Date bond was cancelled
cancellation_reason = (
    claim,
    non_payment,
    obligee_request,
    principal_request,
    surety_decision
):if status = cancelled                           ; Reason for cancellation

release_date = date:if status = released          ; Date bond was released
release_document_number = ::if status = released  ; Release document number

; ───────────────────────────────────────────────────────────────────────────────
; Claims
; ───────────────────────────────────────────────────────────────────────────────
{@surety_bond.claims[]}
id = :                                            ; Unique identifier for claim
date = date                                       ; Date claim was filed
claimant_name = :                                 ; Name of claimant
claimant_type = (obligee, other, subcontractor, supplier)  ; Type of claimant
amount = #$:(0..)                                 ; Claim amount
description = :                                   ; Description of claim
status = (closed, denied, investigating, open, paid, reserved)  ; Claim status
amount_paid = #$:(0..):if status = paid           ; Amount paid on claim
payment_date = date:if status = paid              ; Date claim was paid
subrogation_recovery = #$:(0..)                   ; Amount recovered through subrogation

{@surety_bond}

; ═══════════════════════════════════════════════════════════════════════════════
; Surety Bond Program (Aggregate/Account Level)
; ═══════════════════════════════════════════════════════════════════════════════

{@surety_program}
id = :                                            ; Unique identifier for surety program

; Principal
principal = @bond_principal                       ; Principal under the program

; ───────────────────────────────────────────────────────────────────────────────
; Program Limits
; ───────────────────────────────────────────────────────────────────────────────
single_bond_limit = #$:(0..)                      ; Maximum single bond amount allowed
aggregate_limit = #$:(0..)                        ; Total aggregate bond limit
work_on_hand_limit = #$:(0..)                     ; Maximum work on hand allowed

; SBA Guarantee (if applicable)
sba_guarantee = ?                                 ; Whether program has SBA guarantee
sba_guarantee_percentage = ##:(70, 80, 90):if sba_guarantee = true  ; SBA guarantee percentage
sba_guarantee_fee_percentage = #:(0..5):if sba_guarantee = true  ; SBA guarantee fee percentage

; ───────────────────────────────────────────────────────────────────────────────
; Program Status
; ───────────────────────────────────────────────────────────────────────────────
{.status}
program_status = (active, declined, inactive, suspended)  ; Status of surety program
effective_date = date                             ; Program effective date
review_date = date                                ; Date of last program review
next_financial_due = date                         ; Next financial statement due date

{@surety_program}

; ───────────────────────────────────────────────────────────────────────────────
; Bonds Outstanding
; ───────────────────────────────────────────────────────────────────────────────
{.outstanding}
total_count = ##                                  ; Total number of bonds outstanding
total_amount = #$:(0..)                           ; Total amount of bonds outstanding
bid_bonds_count = ##                              ; Number of bid bonds outstanding
bid_bonds_amount = #$:(0..)                       ; Amount of bid bonds outstanding
performance_bonds_count = ##                      ; Number of performance bonds outstanding
performance_bonds_amount = #$:(0..)               ; Amount of performance bonds outstanding
payment_bonds_count = ##                          ; Number of payment bonds outstanding
payment_bonds_amount = #$:(0..)                   ; Amount of payment bonds outstanding
maintenance_bonds_count = ##                      ; Number of maintenance bonds outstanding
maintenance_bonds_amount = #$:(0..)               ; Amount of maintenance bonds outstanding
commercial_bonds_count = ##                       ; Number of commercial bonds outstanding
commercial_bonds_amount = #$:(0..)                ; Amount of commercial bonds outstanding

{@surety_program}

; ───────────────────────────────────────────────────────────────────────────────
; Work in Progress
; ───────────────────────────────────────────────────────────────────────────────
{.work_in_progress}
total_contract_value = #$:(0..)                   ; Total value of contracts in progress
total_completed_to_date = #$:(0..)                ; Total value of work completed to date
total_remaining = #$:(0..)                        ; Total value of remaining work
project_count = ##                                ; Number of projects in progress

{@surety_program}

; ───────────────────────────────────────────────────────────────────────────────
; Bonds List Reference
; ───────────────────────────────────────────────────────────────────────────────
bonds[] = @surety_bond                            ; List of bonds in the program

; ═══════════════════════════════════════════════════════════════════════════════
; Treasury Listing Reference
; ═══════════════════════════════════════════════════════════════════════════════

{@treasury_listing}
; Circular 570 Surety Information
surety_name = :                                   ; Name of surety company
treasury_number = :(10)                           ; Treasury listing number (10 digits)
underwriting_limitation = #$:(0..)                ; Maximum underwriting limitation
state_licenses[] = :(2)                           ; US states licensed
admitted_states[] = :(2)                          ; States where admitted
reinsurance_agreements = ?                        ; Whether surety has reinsurance agreements


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Legal Client Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Client records for law firm practice management including individual,
; corporate, government, and pro bono clients. Covers contact information,
; billing preferences, conflict checks, engagement terms, and trust
; account management.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common
@import "../../insurance/common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.party.client"
version = "1.0.0"
title = "Legal Client Schema"
description = "Law firm client records and management"

{$derivation}
source[0].authority = "American Bar Association"
source[0].citation = "Model Rules of Professional Conduct Rules 1.1-1.18"
source[0].url = "https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/"

source[1].authority = "Legal Electronic Data Exchange Standard"
source[1].citation = "LEDES Client/Matter Identification"
source[1].url = "https://ledes.org/"

source[2].authority = "State Bar Associations"
source[2].citation = "Client Trust Account Regulations"
source[2].url = "https://www.americanbar.org/groups/professional_responsibility/publications/model_rules_of_professional_conduct/rule_1_15_safekeeping_property/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Client schema derived from ABA Model Rules and LEDES standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial legal client schema"
changelog[0].rationale = "Comprehensive client management structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL CLIENT
; ═══════════════════════════════════════════════════════════════════════════════
; Primary client record

{@legal_client}
; Required fields first
client_name = !:                                  ; Client name (individual or entity)
client_type = !(corporation, estate, government, individual, llc, nonprofit, other_entity, partnership, trust)
open_date = !date                                 ; Date client opened

; Client identification
client_id = :                                     ; Internal client identifier
client_number = :                                 ; Client number
ledes_client_id = :                               ; LEDES client ID

; ───────────────────────────────────────────────────────────────────────────────
; Individual Client Details
; ───────────────────────────────────────────────────────────────────────────────
{.individual}
person_ref = @person:if client_type = individual  ; Reference to person record
date_of_birth = *date:if client_type = individual ; Date of birth
ssn = *:format ssn:if client_type = individual ; SSN

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Entity Client Details
; ───────────────────────────────────────────────────────────────────────────────
{.entity}
organization_ref = @organization:if client_type != individual ; Reference to organization
tax_id = *::if client_type != individual          ; EIN or other tax ID
jurisdiction_of_formation = ::if client_type != individual
date_of_formation = date:if client_type != individual
registered_agent = ::if client_type != individual ; Registered agent name
public_company = ?:if client_type = corporation   ; Publicly traded
stock_symbol = ::if public_company = true         ; Stock ticker symbol
fiscal_year_end = ::if client_type != individual  ; Fiscal year end month

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
primary_address = @address                        ; Primary address
mailing_address = @address                        ; Mailing address (if different)
phones[] = *@phone                                ; Phone numbers
email = *@email                                   ; Primary email
website = :                                       ; Client website

{@legal_client}

; Primary contact (for entity clients)
{.contact.primary}
contact_name = ::if client_type != individual     ; Primary contact name
contact_title = ::if client_type != individual    ; Contact title
contact_phone = *@phone:if client_type != individual
contact_email = *@email:if client_type != individual

{@legal_client}

; Additional contacts
contacts[] = @client_contact                      ; Additional contacts

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Engagement Information
; ───────────────────────────────────────────────────────────────────────────────
{.engagement}
originating_attorney = :                          ; Originating attorney name
originating_attorney_ref = @legal_attorney        ; Reference to attorney
responsible_attorney = :                          ; Responsible/billing attorney
responsible_attorney_ref = @legal_attorney        ; Reference to attorney
client_source = (advertising, conference, existing_client, internet, referral_attorney, referral_client, referral_other, walk_in)
referral_source = ::if client_source = referral_attorney | client_source = referral_client | client_source = referral_other
industry = :                                      ; Client industry
industry_code = :                                 ; SIC or NAICS code

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Conflict Check
; ───────────────────────────────────────────────────────────────────────────────
{.conflict}
conflict_check_completed = ?                      ; Conflict check done
conflict_check_date = date:if conflict_check_completed = true
conflict_check_ref = @legal_conflict_check        ; Reference to conflict check
conflict_waiver_required = ?                      ; Waiver needed
waiver_obtained = ?:if conflict_waiver_required = true
waiver_date = date:if waiver_obtained = true
waiver_description = ::if waiver_obtained = true

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Billing Information
; ───────────────────────────────────────────────────────────────────────────────
billing = @client_billing                         ; Billing configuration

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Retainer
; ───────────────────────────────────────────────────────────────────────────────
retainer = @legal_retainer                        ; Retainer terms

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Trust Account
; ───────────────────────────────────────────────────────────────────────────────
{.trust_account}
trust_balance = #$                                ; Current trust balance
trust_account_number = *:                         ; Trust account number
minimum_trust_balance = #$:(0..)                  ; Minimum required balance
last_trust_statement = date                       ; Last trust statement date

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Matters
; ───────────────────────────────────────────────────────────────────────────────
active_matters_count = ##:(0..)                   ; Active matters count
closed_matters_count = ##:(0..)                   ; Closed matters count
matters[] = @legal_matter_ref                     ; References to matters

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Client Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
client_tier = (a, b, c, strategic)                ; Client tier/importance
pro_bono = ?                                      ; Pro bono client
low_income = ?:if pro_bono = true                 ; Low income qualification
approved_nonprofit = ?:if pro_bono = true         ; Approved nonprofit
practice_area = :                                 ; Primary practice area
client_team[] = @legal_attorney                   ; Client team attorneys

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Outside Counsel Guidelines
; ───────────────────────────────────────────────────────────────────────────────
{.guidelines}
outside_counsel_guidelines = ?                    ; Client has OCG
ocg_version = :                                   ; OCG version/date
staffing_restrictions = ?                         ; Staffing level restrictions
rate_restrictions = ?                             ; Rate restrictions
billing_restrictions = ?                          ; Billing restrictions (block billing, etc.)
ebilling_required = ?                             ; Electronic billing required
ebilling_vendor = ::if ebilling_required = true   ; E-billing vendor name
preferred_formats[] = (ledes_1998b, ledes_2000, ledes_xml)
task_codes_required = ?                           ; UTBMS codes required

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Preferences
; ───────────────────────────────────────────────────────────────────────────────
{.preferences}
preferred_contact_method = (email, mail, phone)   ; Preferred contact
billing_email = *@email                           ; Billing email
cc_emails[] = *@email                             ; CC on correspondence
special_instructions = :                          ; Special handling instructions
do_not_contact = ?                                ; Do not contact flag
do_not_contact_reason = ::if do_not_contact = true

{@legal_client}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, closed, collection, inactive, prospective, suspended)
status_date = date                                ; Date of current status
close_date = date:if status = closed              ; Date closed
close_reason = (completed, conflict, fee_dispute, non_payment, other, relationship):if status = closed
reopen_eligible = ?:if status = closed            ; Eligible to reopen

; ═══════════════════════════════════════════════════════════════════════════════
; CLIENT CONTACT
; ═══════════════════════════════════════════════════════════════════════════════
; Client contact person

{@client_contact}
; Required fields first
contact_name = !:                                 ; Contact name
contact_type = !(billing, general, in_house_counsel, primary, secondary)

; Contact details
{.details}
title = :                                         ; Title/position
department = :                                    ; Department
phone = *@phone                                   ; Phone number
email = *@email                                   ; Email address
address = @address                                ; Address (if different from client)

{@client_contact}

; Role and authority
{.authority}
authorized_signer = ?                             ; Can sign documents
billing_contact = ?                               ; Receives invoices
receives_correspondence = ?                       ; Receives correspondence
decision_maker = ?                                ; Key decision maker
engagement_authority = ?                          ; Can authorize new matters

{@client_contact}

; Preferences
preferred_contact_method = (email, mail, phone)   ; Preferred contact method
assistant_name = :                                ; Assistant name
assistant_phone = *@phone                         ; Assistant phone
assistant_email = *@email                         ; Assistant email

; Status
active = ?                                        ; Contact is active

; ═══════════════════════════════════════════════════════════════════════════════
; CLIENT BILLING
; ═══════════════════════════════════════════════════════════════════════════════
; Client billing configuration

{@client_billing}
; Required fields first
billing_method = !(alternative_fee, blended_rate, contingency, fixed_fee, hourly, hybrid)

; ───────────────────────────────────────────────────────────────────────────────
; Rates
; ───────────────────────────────────────────────────────────────────────────────
{.rates}
rate_effective_date = date                        ; Rate effective date
rate_review_date = date                           ; Next rate review
standard_rates = ?                                ; Standard rates apply
discount_percentage = #:(0..100)                  ; Discount percentage
blended_rate = #$:(0..):if billing_method = blended_rate ; Blended hourly rate
fixed_fee_amount = #$:(0..):if billing_method = fixed_fee ; Fixed fee amount
contingency_percentage = #:(0..100):if billing_method = contingency

{@client_billing}

; Timekeeper rates (if custom rates)
{.rates.custom[]}
timekeeper_name = :                               ; Timekeeper name
timekeeper_classification = :                     ; Classification
hourly_rate = #$:(0..)                            ; Agreed hourly rate
rate_cap = #$:(0..)                               ; Rate cap (if any)

{@client_billing}

; ───────────────────────────────────────────────────────────────────────────────
; Billing Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
billing_frequency = (biweekly, monthly, on_completion, quarterly, upon_request)
payment_terms_days = ##:(0..)                     ; Days for payment
late_fee_percentage = #:(0..100)                  ; Late payment fee
interest_rate = #:(0..100)                        ; Interest on overdue

{@client_billing}

; ───────────────────────────────────────────────────────────────────────────────
; Invoice Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.invoice}
invoice_format = (ledes_1998b, ledes_2000, ledes_xml, paper, pdf)
electronic_delivery = ?                           ; Electronic delivery
delivery_email = *@email:if electronic_delivery = true
cc_emails[] = *@email                             ; CC on invoices
billing_address = @address                        ; Billing address
po_required = ?                                   ; PO required on invoices
po_number = ::if po_required = true               ; Current PO number
pre_bill_required = ?                             ; Pre-bill review required
pre_bill_contact = ::if pre_bill_required = true  ; Pre-bill contact

{@client_billing}

; ───────────────────────────────────────────────────────────────────────────────
; Expense Guidelines
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
expenses_billed = ?                               ; Bill expenses
expense_markup = #:(0..100)                       ; Expense markup percentage
travel_expenses = ?                               ; Travel expenses billable
meal_per_diem = #$:(0..)                          ; Meal per diem cap
mileage_rate = #:(0..)                            ; Mileage rate
research_charges = ?                              ; Bill research (Westlaw, etc.)
copying_rate = #:(0..)                            ; Per page copying rate
preapproval_threshold = #$:(0..)                  ; Threshold requiring approval

{@client_billing}

; ───────────────────────────────────────────────────────────────────────────────
; Electronic Billing
; ───────────────────────────────────────────────────────────────────────────────
{.ebilling}
ebilling_enabled = ?                              ; E-billing enabled
ebilling_vendor = ::if ebilling_enabled = true    ; E-billing vendor
vendor_client_id = ::if ebilling_enabled = true   ; Client ID in vendor system
vendor_matter_id = ::if ebilling_enabled = true   ; Matter ID in vendor system
ledes_format = (ledes_1998b, ledes_2000, ledes_xml):if ebilling_enabled = true
utbms_codes_required = ?:if ebilling_enabled = true
auto_reject_rules = ?:if ebilling_enabled = true  ; Auto-rejection rules

{@client_billing}

; ───────────────────────────────────────────────────────────────────────────────
; Budget
; ───────────────────────────────────────────────────────────────────────────────
{.budget}
budget_required = ?                               ; Budgets required
budget_approval_required = ?                      ; Budget approval needed
budget_variance_threshold = #:(0..100)            ; Variance threshold for alert
matter_budget_cap = #$:(0..)                      ; Default matter budget cap

{@client_billing}

; Status
billing_active = ?                                ; Billing is active
billing_suspended = ?                             ; Billing suspended
suspension_reason = ::if billing_suspended = true ; Suspension reason

; ═══════════════════════════════════════════════════════════════════════════════
; LEGAL PARTY (GENERIC)
; ═══════════════════════════════════════════════════════════════════════════════
; Generic party in a legal matter (used for non-client parties)

{@legal_party}
; Required fields first
party_name = !:                                   ; Party name
party_type = !(corporation, estate, government, individual, llc, nonprofit, other, partnership, trust)

; Party identification
party_id = :                                      ; Unique party identifier

; ───────────────────────────────────────────────────────────────────────────────
; Individual Party Details
; ───────────────────────────────────────────────────────────────────────────────
{.individual}
person_ref = @person:if party_type = individual   ; Reference to person record
date_of_birth = *date:if party_type = individual  ; Date of birth

{@legal_party}

; ───────────────────────────────────────────────────────────────────────────────
; Entity Party Details
; ───────────────────────────────────────────────────────────────────────────────
{.entity}
organization_ref = @organization:if party_type != individual ; Reference to organization
jurisdiction_of_formation = ::if party_type != individual
agent_for_service = ::if party_type != individual ; Agent for service

{@legal_party}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
address = @address                                ; Address
phone = *@phone                                   ; Phone
email = *@email                                   ; Email

{@legal_party}

; Representation
represented = ?                                   ; Has legal representation
counsel_ref = @legal_opposing_counsel:if represented = true ; Counsel reference
pro_se = ?:if represented = false                 ; Proceeding pro se

; Role in matter
role = :                                          ; Role in matter


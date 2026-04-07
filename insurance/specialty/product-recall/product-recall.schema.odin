; ===================================================================================
; ODIN Product Recall Insurance Schema
; ===================================================================================
; Product recall insurance covering first-party recall expenses and third-party
; liability from mandatory or voluntary product recalls including government-
; ordered, voluntary, and market withdrawal actions.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.product-recall"
version = "1.0.0"
title = "Product Recall Insurance Schema"
description = "Coverage for product recall expenses and related losses"

{$derivation}
source[0].authority = "Consumer Product Safety Commission (CPSC)"
source[0].citation = "Product Recall Requirements and Procedures"
source[0].url = "https://www.cpsc.gov/"

source[1].authority = "Food and Drug Administration (FDA)"
source[1].citation = "Food and Drug Recall Regulations"
source[1].url = "https://www.fda.gov/"

source[2].authority = "National Highway Traffic Safety Administration"
source[2].citation = "Motor Vehicle and Equipment Recall Procedures"
source[2].url = "https://www.nhtsa.gov/"

source[3].authority = "Product Liability Advisory Council"
source[3].citation = "Product Recall Insurance Guidelines"
source[3].url = "https://web.archive.org/web/20221208114319/https://plac.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on CPSC, FDA, and industry recall insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial product recall insurance schema"
changelog[0].rationale = "Specialty coverage for product recall exposures"

; ===================================================================================
; Insured Manufacturer
; ===================================================================================

{@recall_insured}
; Required fields first
annual_revenue = !#$:(0..)                    ; Annual revenue
business_name = !:                            ; Company name
industry = !(
    automotive,                               ; Automotive/parts
    chemicals,                                ; Chemicals
    consumer_goods,                           ; Consumer products
    cosmetics,                                ; Cosmetics
    electronics,                              ; Electronics
    food_beverage,                            ; Food/beverage
    household,                                ; Household products
    medical_device,                           ; Medical devices
    pharmaceutical,                           ; Pharmaceuticals
    supplements,                              ; Dietary supplements
    tobacco,                                  ; Tobacco
    toys                                      ; Toys/children's products
)

; Optional fields
address = @address                            ; HQ address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
distribution_channels[] = :                   ; Distribution channels
employee_count = ##                           ; Employees
export_countries[] = :                        ; Export markets
fein = *:                                     ; Tax ID
fda_registered = ?                            ; FDA registration
gmp_certified = ?                             ; GMP certification
haccp_plan = ?                                ; HACCP certified
insured_id = :                                ; Internal identifier
iso_certified = ?                             ; ISO certification
manufacturing_locations[] = :                 ; Manufacturing sites
product_categories[] = :                      ; Product categories
product_count = ##                            ; Number of products
quality_system = :                            ; Quality system
recall_history = ##                           ; Prior recalls
traceability_system = ?                       ; Traceability

; ===================================================================================
; Product Information
; ===================================================================================

{@recall_product}
; Required fields first
product_category = !:                         ; Product category
product_name = !:                             ; Product name/line
annual_sales = #$:(0..)                       ; Annual product sales

; Optional fields
batch_tracking = ?                            ; Batch/lot tracking
distribution_scope = (international, national, regional)
fda_class = (class_1, class_2, class_3):if industry = (food_beverage, pharmaceutical, medical_device)
gtin_upc = :                                  ; GTIN/UPC code
manufacturing_location = :                    ; Where made
private_label = ?                             ; Private label
product_id = :                                ; Internal identifier
regulatory_approval = :                       ; Approval reference
shelf_life_days = ##                          ; Shelf life
sku_count = ##                                ; SKU count
unit_price = #$:(0..)                         ; Unit price
units_produced = ##                           ; Annual units

; ===================================================================================
; Recall Coverage
; ===================================================================================

{@recall_coverage}
; Required fields first
aggregate_limit = !#$:(0..)                   ; Annual aggregate
each_recall_limit = !#$:(0..)                 ; Per recall limit

; Optional fields
deductible = #$:(0..)                         ; Deductible
retention = #$:(0..)                          ; Self-insured retention
waiting_period_days = ##                      ; Waiting period

; Recall triggers
accidental_contamination = ?                  ; Accidental contamination
allergen = ?                                  ; Allergen mislabeling
defect = ?                                    ; Product defect
foreign_object = ?                            ; Foreign object
government_order = ?                          ; Mandated recall
malicious_tampering = ?                       ; Tampering
mislabeling = ?                               ; Mislabeling
pathogen = ?                                  ; Pathogen contamination
regulatory_non_compliance = ?                 ; Non-compliance
voluntary = ?                                 ; Voluntary recall

; ---------------------------------------------------------------------------
; Recall Expenses
; ---------------------------------------------------------------------------
{.recall_expenses}
included = ?                                  ; Recall expenses covered
advertising = ?:if included = true            ; Ad/notification costs
call_center = ?:if included = true            ; Call center costs
consultant_fees = ?:if included = true        ; Recall consultant
customer_communication = ?:if included = true ; Customer notification
destruction_disposal = ?:if included = true   ; Destruction costs
limit = #$:(0..):if included = true           ; Expense limit
logistics = ?:if included = true              ; Logistics/retrieval
refund_replacement = ?:if included = true     ; Refund/replacement
shipping = ?:if included = true               ; Shipping costs
storage = ?:if included = true                ; Storage costs
testing = ?:if included = true                ; Laboratory testing

{@recall_coverage}

; ---------------------------------------------------------------------------
; Business Interruption
; ---------------------------------------------------------------------------
{.business_interruption}
included = ?                                  ; BI coverage
daily_limit = #$:(0..):if included = true     ; Daily limit
extra_expense = ?:if included = true          ; Extra expense
indemnity_period_days = ##:if included = true ; Indemnity period
limit = #$:(0..):if included = true           ; BI limit
lost_profit = ?:if included = true            ; Lost profit
waiting_period_days = ##:if included = true   ; Waiting period

{@recall_coverage}

; ---------------------------------------------------------------------------
; Rehabilitation/Brand Protection
; ---------------------------------------------------------------------------
{.rehabilitation}
included = ?                                  ; Rehabilitation coverage
advertising = ?:if included = true            ; Marketing costs
crisis_management = ?:if included = true      ; Crisis PR
limit = #$:(0..):if included = true           ; Rehab limit
public_relations = ?:if included = true       ; PR costs
reputation_repair = ?:if included = true      ; Reputation costs

{@recall_coverage}

; ---------------------------------------------------------------------------
; Third-Party Recall
; ---------------------------------------------------------------------------
{.third_party}
included = ?                                  ; Third-party recall
customer_recall = ?:if included = true        ; Customer's recall costs
limit = #$:(0..):if included = true           ; Third-party limit
supplier_defect = ?:if included = true        ; Supplier caused

{@recall_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@recall_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
bi_premium = #$:(0..)                         ; BI premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
recall_premium = #$:(0..)                     ; Recall expense
rehabilitation_premium = #$:(0..)             ; Rehabilitation
taxes_and_fees = #$:(0..)                     ; Taxes/fees
third_party_premium = #$:(0..)                ; Third-party

; Rating factors
rate_per_revenue = #                          ; Rate per $1M revenue

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claims_experience = #                         ; Loss history
distribution_factor = #                       ; Distribution scope
industry_factor = #                           ; Industry class
quality_factor = #                            ; Quality systems
revenue_factor = #                            ; Revenue tier
traceability_factor = #                       ; Traceability credit

{@recall_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@recall_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    allergen,                                 ; Allergen issue
    bacterial,                                ; Bacterial contamination
    chemical,                                 ; Chemical contamination
    defect,                                   ; Product defect
    foreign_object,                           ; Foreign object
    mislabeling,                              ; Mislabeling
    packaging,                                ; Packaging defect
    tampering,                                ; Tampering
    viral,                                    ; Viral contamination
    other                                     ; Other
)
recall_trigger = !(
    complaint,                                ; Consumer complaint
    government,                               ; Government order
    internal,                                 ; Internal discovery
    supplier,                                 ; Supplier notification
    testing                                   ; Routine testing
)

; Optional fields
affected_units = ##                           ; Units affected
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
bi_loss = #$:(0..)                            ; BI loss amount
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    open,
    paid,
    reserved
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
geographic_scope = :                          ; Recall scope
illnesses_injuries = ##                       ; Reported illnesses
incident_date = date                          ; Discovery date
product_affected = :                          ; Product name
recall_class = (class_1, class_2, class_3)    ; FDA recall class
recall_expense = #$:(0..)                     ; Recall costs
rehabilitation_expense = #$:(0..)             ; Rehab costs
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Product Recall Policy
; ===================================================================================

{@recall_policy}
; Required fields first
coverage = !@recall_coverage                  ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
insured = !@recall_insured                    ; Insured company
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @recall_claim                      ; Claims history
endorsements[] = :                            ; Policy endorsements
excluded_products[] = :                       ; Excluded products
id = :                                        ; Internal identifier
policy_form = (
    first_party,                              ; First-party only
    full,                                     ; Comprehensive
    third_party                               ; Third-party only
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @recall_premium                     ; Premium details
producer = @producer                          ; Agent
products[] = @recall_product                  ; Covered products
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
aggregate_limit = #$:(0..)                    ; Aggregate limit
annual_revenue = #$:(0..)                     ; Annual revenue
each_recall_limit = #$:(0..)                  ; Per recall limit
insured_name = :                              ; Company name
industry = :                                  ; Industry sector

{@recall_policy}


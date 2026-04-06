; ===================================================================================
; ODIN Political Risk Insurance Schema
; ===================================================================================
; Political risk insurance covering confiscation/expropriation/nationalization,
; political violence, currency inconvertibility, contract frustration, and
; sovereign/subsovereign non-payment for international operations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.political-risk"
version = "1.0.0"
title = "Political Risk Insurance Schema"
description = "Coverage for foreign investments against political perils"

{$derivation}
source[0].authority = "Multilateral Investment Guarantee Agency (MIGA)"
source[0].citation = "Political Risk Insurance Standards"
source[0].url = "https://www.miga.org/"

source[1].authority = "U.S. International Development Finance Corporation"
source[1].citation = "Political Risk Insurance Programs"
source[1].url = "https://www.dfc.gov/"

source[2].authority = "Berne Union"
source[2].citation = "Investment Insurance Principles"
source[2].url = "https://www.berneunion.org/"

source[3].authority = "Lloyd's of London"
source[3].citation = "Political Risks - Specialty Insurance"
source[3].url = "https://www.lloyds.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on MIGA, DFC, and Lloyd's political risk standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial political risk insurance schema"
changelog[0].rationale = "Specialty coverage for foreign investment protection"

; ===================================================================================
; Insured Entity
; ===================================================================================

{@pri_insured}
; Required fields first
insured_name = !:                             ; Entity name
insured_type = !(
    bank,                                     ; Commercial bank
    contractor,                               ; International contractor
    corporation,                              ; MNC
    dfi,                                      ; Development finance inst
    exporter,                                 ; Exporter
    fund,                                     ; PE/infrastructure fund
    government,                               ; Government entity
    manufacturer,                             ; Manufacturer
    project_company,                          ; Project company
    utility                                   ; Utility company
)

; Optional fields
address = @address                            ; HQ address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
country_of_incorporation = :                  ; Home country
fein = *:                                     ; Tax ID
insured_id = :                                ; Internal identifier
parent_company = :                            ; Parent entity
sector = :                                    ; Business sector
years_in_host_country = ##                    ; Operating history

; ===================================================================================
; Investment Details
; ===================================================================================

{@pri_investment}
; Required fields first
host_country = !:                             ; Host country
investment_type = !(
    bond,                                     ; Sovereign/corp bond
    branch,                                   ; Branch operation
    concession,                               ; Concession agreement
    equity,                                   ; Equity investment
    joint_venture,                            ; Joint venture
    loan,                                     ; Cross-border loan
    project_finance,                          ; Project finance
    subsidiary,                               ; Subsidiary
    supply_contract                           ; Supply/service contract
)
investment_value = !#$:(0..)                  ; Investment amount

; Optional fields
counterparty = :                              ; Government counterparty
currency = :                                  ; Investment currency
equity_percentage = #:(0..100)                ; Ownership %
government_guarantee = ?                      ; Government guarantee
investment_date = date                        ; Date of investment
investment_id = :                             ; Internal identifier
investment_term_years = ##                    ; Investment term
local_partner = :                             ; Local partner
project_name = :                              ; Project name
sector = (
    agriculture,                              ; Agriculture
    energy,                                   ; Energy/power
    financial_services,                       ; Financial services
    infrastructure,                           ; Infrastructure
    manufacturing,                            ; Manufacturing
    mining,                                   ; Mining
    oil_gas,                                  ; Oil and gas
    real_estate,                              ; Real estate
    telecommunications,                       ; Telecom
    transportation,                           ; Transportation
    water                                     ; Water/utilities
)

; ===================================================================================
; Political Risk Coverage
; ===================================================================================

{@pri_coverage}
; Required fields first
insured_percentage = !#:(0..100)              ; Coverage percentage
maximum_liability = !#$:(0..)                 ; Policy limit

; Coverage term
policy_term_years = ##                        ; Policy term
standby_period_years = ##                     ; Standby period
waiting_period_days = ##                      ; Wait before claim

; Deductible
deductible = #$:(0..)                         ; Deductible amount
deductible_percentage = #:(0..100)            ; Deductible %

; ---------------------------------------------------------------------------
; Expropriation
; ---------------------------------------------------------------------------
{.expropriation}
included = ?                                  ; Expropriation coverage
confiscation = ?:if included = true           ; Confiscation
creeping_expropriation = ?:if included = true ; Creeping/constructive
direct_expropriation = ?:if included = true   ; Direct taking
forced_divestiture = ?:if included = true     ; Forced sale
limit = #$:(0..):if included = true           ; Expropriation limit
nationalization = ?:if included = true        ; Nationalization
percentage = #:(0..100):if included = true    ; Indemnity %
selective_discrimination = ?:if included = true   ; Discrimination
waiting_period_days = ##:if included = true   ; Wait period

{@pri_coverage}

; ---------------------------------------------------------------------------
; Political Violence
; ---------------------------------------------------------------------------
{.political_violence}
included = ?                                  ; PV coverage
business_interruption = ?:if included = true  ; PV BI
civil_commotion = ?:if included = true        ; Civil commotion
civil_war = ?:if included = true              ; Civil war
coup = ?:if included = true                   ; Coup d'etat
forced_abandonment = ?:if included = true     ; Forced abandonment
insurrection = ?:if included = true           ; Insurrection
limit = #$:(0..):if included = true           ; PV limit
percentage = #:(0..100):if included = true    ; Indemnity %
physical_damage = ?:if included = true        ; PV physical damage
rebellion = ?:if included = true              ; Rebellion
revolution = ?:if included = true             ; Revolution
sabotage = ?:if included = true               ; Sabotage
strikes_riots = ?:if included = true          ; Strikes/riots
terrorism = ?:if included = true              ; Terrorism
war = ?:if included = true                    ; War

{@pri_coverage}

; ---------------------------------------------------------------------------
; Currency Inconvertibility / Transfer
; ---------------------------------------------------------------------------
{.currency}
included = ?                                  ; Currency coverage
active_blockage = ?:if included = true        ; Active blockage
currency_depreciation = ?:if included = true  ; Depreciation (rare)
exchange_rate = (historical, spot):if included = true  ; Rate basis
inconvertibility = ?:if included = true       ; Inconvertibility
limit = #$:(0..):if included = true           ; Currency limit
moratorium = ?:if included = true             ; Moratorium
passive_blockage = ?:if included = true       ; Passive blockage
percentage = #:(0..100):if included = true    ; Indemnity %
transfer_restriction = ?:if included = true   ; Transfer restriction
waiting_period_days = ##:if included = true   ; Wait period

{@pri_coverage}

; ---------------------------------------------------------------------------
; Breach of Contract
; ---------------------------------------------------------------------------
{.breach_of_contract}
included = ?                                  ; BOC coverage
arbitral_award_default = ?:if included = true ; Award default
denial_of_justice = ?:if included = true      ; Denial of justice
government_breach = ?:if included = true      ; Government breach
limit = #$:(0..):if included = true           ; BOC limit
non_honoring = ?:if included = true           ; Non-honoring
percentage = #:(0..100):if included = true    ; Indemnity %
repudiation = ?:if included = true            ; Repudiation

{@pri_coverage}

; ===================================================================================
; Premium Details
; ===================================================================================

{@pri_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
boc_premium = #$:(0..)                        ; Breach of contract
currency_premium = #$:(0..)                   ; Currency coverage
expropriation_premium = #$:(0..)              ; Expropriation
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
pv_premium = #$:(0..)                         ; Political violence
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; Rating basis
annual_rate = #                               ; Annual rate %
premium_basis = (
    annual,                                   ; Annual premium
    single,                                   ; Single premium
    standby                                   ; Standby fee
)
standby_rate = #                              ; Standby rate

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
country_factor = #                            ; Country risk rating
investment_factor = #                         ; Investment type
sector_factor = #                             ; Sector risk
term_factor = #                               ; Policy term

{@pri_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@pri_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    arbitral_default,                         ; Arbitral award default
    civil_war,                                ; Civil war
    confiscation,                             ; Confiscation
    currency_blockage,                        ; Currency blockage
    expropriation,                            ; Expropriation
    forced_abandonment,                       ; Forced abandonment
    government_breach,                        ; Government breach
    inconvertibility,                         ; Inconvertibility
    nationalization,                          ; Nationalization
    political_violence,                       ; Political violence
    repudiation,                              ; Contract repudiation
    terrorism,                                ; Terrorism
    transfer_restriction,                     ; Transfer restriction
    war,                                      ; War
    other                                     ; Other
)
host_country = !:                             ; Country of loss

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    arbitration,
    closed,
    denied,
    open,
    paid,
    reserved,
    subrogation
)
deductible_applied = #$:(0..)                 ; Deductible
description = :                               ; Description
government_action = :                         ; Government action
incident_date = date                          ; Incident date
investment_reference = :                      ; Investment ID
recovery = #$:(0..)                           ; Recovery amount
reserve = #$:(0..)                            ; Reserve amount
subrogation_status = :                        ; Subrogation status

; ===================================================================================
; Political Risk Policy
; ===================================================================================

{@pri_policy}
; Required fields first
coverage = !@pri_coverage                     ; Coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
insured = !@pri_insured                       ; Insured entity
investment = !@pri_investment                 ; Investment details
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @pri_claim                         ; Claims history
endorsements[] = :                            ; Policy endorsements
excluded_perils[] = :                         ; Excluded perils
id = :                                        ; Internal identifier
loss_payee = :                                ; Loss payee (lender)
policy_form = (
    comprehensive,                            ; All perils
    equity,                                   ; Equity investment
    lender,                                   ; Lender policy
    project_finance,                          ; Project finance
    selective                                 ; Selected perils
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    standby
)
premium = @pri_premium                        ; Premium details
producer = @producer                          ; Agent
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
host_country = :                              ; Host country
insured_name = :                              ; Insured name
insured_percentage = #:(0..100)               ; Coverage %
investment_value = #$:(0..)                   ; Investment amount
maximum_liability = #$:(0..)                  ; Policy limit

{@pri_policy}


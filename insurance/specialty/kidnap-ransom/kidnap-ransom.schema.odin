; ===================================================================================
; ODIN Kidnap and Ransom Insurance Schema
; ===================================================================================
; Kidnap, ransom, and extortion insurance (K&R) covering ransom payments, crisis
; response consulting, insured personal accident, loss of income, and legal
; liability for employees and executives in high-risk situations.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.kidnap-ransom"
version = "1.0.0"
title = "Kidnap and Ransom Insurance Schema"
description = "Crisis coverage for kidnapping, extortion, and detention events"

{$derivation}
source[0].authority = "Lloyd's of London"
source[0].citation = "Special Risks - Kidnap and Ransom Insurance"
source[0].url = "https://www.lloyds.com/"

source[1].authority = "Overseas Security Advisory Council (OSAC)"
source[1].citation = "Kidnapping and Extortion Prevention Guidelines"
source[1].url = "https://www.state.gov/bureaus-offices/under-secretary-for-management/bureau-of-diplomatic-security/overseas-security-advisory-council/"

source[2].authority = "International Risk Management Institute (IRMI)"
source[2].citation = "Kidnap and Ransom Insurance Coverage"
source[2].url = "https://www.irmi.com/"

source[3].authority = "FBI - International Operations Division"
source[3].citation = "International Kidnapping Response"
source[3].url = "https://www.fbi.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on Lloyd's K&R market and specialty insurance standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial kidnap and ransom insurance schema"
changelog[0].rationale = "Specialty crisis coverage for K&R exposures"

; ===================================================================================
; Insured Classification
; ===================================================================================

{@kr_insured_type}
organization_type = !(
    construction,                             ; Construction company
    corporation,                              ; Multinational corp
    educational,                              ; University/school
    energy,                                   ; Energy company
    family_office,                            ; Family office
    financial,                                ; Financial services
    government_contractor,                    ; Gov contractor
    healthcare,                               ; Healthcare org
    high_net_worth,                           ; HNWI/family
    hospitality,                              ; Hotel/tourism
    manufacturing,                            ; Manufacturer
    media,                                    ; Media organization
    mining,                                   ; Mining company
    ngo,                                      ; Non-profit/NGO
    pharmaceutical,                           ; Pharma company
    technology                                ; Tech company
)

; Risk profile
risk_tier = (
    extreme,                                  ; Extreme risk regions
    high,                                     ; High risk regions
    low,                                      ; Low risk areas
    moderate                                  ; Moderate risk
)

; ===================================================================================
; Insured Organization
; ===================================================================================

{@kr_insured}
; Required fields first
annual_revenue = !#$:(0..)                    ; Annual revenue
insured_name = !:                             ; Organization name
insured_type = !@kr_insured_type              ; Organization class

; Optional fields
address = @address                            ; HQ address
contact_email = *@email                       ; Contact email
contact_phone = *@phone                       ; Contact phone
crisis_plan = ?                               ; Crisis management plan
employee_count = ##                           ; Total employees
expatriates = ##                              ; Expat employees
fein = *:                                     ; Tax ID
foreign_locations[] = :                       ; International locations
high_risk_travelers = ##                      ; High-risk travelers
insured_id = :                                ; Internal identifier
international_operations = ?                  ; International ops
key_employees = ##                            ; Named key employees
security_assessment = ?                       ; Security audit done
security_provider = :                         ; Security firm
travel_frequency = (frequent, moderate, rare) ; Travel volume

; ===================================================================================
; K&R Coverage
; ===================================================================================

{@kr_coverage}
; Required fields first
aggregate_limit = !#$:(0..)                   ; Annual aggregate
per_insured_limit = !#$:(0..)                 ; Per insured limit

; Core coverage
accidental_death = ?                          ; AD&D benefit
ad_limit = #$:(0..):if accidental_death = true
assault = ?                                   ; Assault coverage
detention = ?                                 ; Wrongful detention
disappearance = ?                             ; Disappearance
express_kidnap = ?                            ; Express/tiger kidnap
extortion = ?                                 ; Extortion threats
hijacking = ?                                 ; Hijacking
hostage = ?                                   ; Hostage taking
kidnapping = ?                                ; Kidnapping
stalking = ?                                  ; Stalking/threat
threat = ?                                    ; Threat coverage

; Deductible/waiting period
deductible = #$:(0..)                         ; Deductible
waiting_period_hours = ##                     ; Hours before coverage

; ---------------------------------------------------------------------------
; Ransom Coverage
; ---------------------------------------------------------------------------
{.ransom}
ransom_limit = #$:(0..)                       ; Ransom payment limit
cryptocurrency = ?                            ; Crypto ransom allowed
delivery_expenses = ?                         ; Delivery costs
in_transit_loss = ?                           ; Loss in transit
negotiation_costs = ?                         ; Negotiation expenses
ransom_payments = ?                           ; Ransom payments covered

{@kr_coverage}

; ---------------------------------------------------------------------------
; Crisis Response
; ---------------------------------------------------------------------------
{.crisis_response}
included = ?                                  ; Crisis response coverage
consultant_fees = #$:(0..):if included = true ; Response consultant
independent_negotiator = ?:if included = true ; Negotiator costs
interpreter = ?:if included = true            ; Interpreter costs
legal_fees = #$:(0..):if included = true      ; Legal costs
media_response = ?:if included = true         ; PR/media consultant
psychological_support = ?:if included = true  ; Psych counseling
security_consultant = ?:if included = true    ; Security consultant
travel_expenses = #$:(0..):if included = true ; Travel costs

{@kr_coverage}

; ---------------------------------------------------------------------------
; Rehabilitation
; ---------------------------------------------------------------------------
{.rehabilitation}
included = ?                                  ; Rehab coverage
cosmetic_surgery = ?:if included = true       ; Cosmetic surgery
limit = #$:(0..):if included = true           ; Rehab limit
medical_treatment = ?:if included = true      ; Medical expenses
period_months = ##:if included = true         ; Coverage period
psychiatric_care = ?:if included = true       ; Psychiatric care
rest_recuperation = ?:if included = true      ; Rest/recuperation

{@kr_coverage}

; ===================================================================================
; Extortion Coverage
; ===================================================================================

{@kr_extortion}
included = ?                                  ; Extortion coverage

; Types of extortion
biological = ?:if included = true             ; Biological threat
cyber = ?:if included = true                  ; Cyber extortion
limit = #$:(0..):if included = true           ; Extortion limit
product_contamination = ?:if included = true  ; Product tampering
product_extortion = ?:if included = true      ; Product extortion
property_threat = ?:if included = true        ; Property threat

; Response costs
consultant = ?:if included = true             ; Extortion consultant
investigation = ?:if included = true          ; Investigation costs
product_recall = ?:if included = true         ; Recall costs

; ===================================================================================
; Legal Liability
; ===================================================================================

{@kr_liability}
included = ?                                  ; Legal liability

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
defense_costs = ?:if included = true          ; Defense costs
each_claim = #$:(0..):if included = true      ; Per claim limit
personal_liability = ?:if included = true     ; Personal liability
third_party = ?:if included = true            ; Third-party claims

; ===================================================================================
; Premium Details
; ===================================================================================

{@kr_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
crisis_response_premium = #$:(0..)            ; Crisis response
extortion_premium = #$:(0..)                  ; Extortion premium
kidnap_premium = #$:(0..)                     ; Kidnap premium
liability_premium = #$:(0..)                  ; Liability premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
rehabilitation_premium = #$:(0..)             ; Rehabilitation
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
employee_factor = #                           ; Employee count
location_factor = #                           ; Location risk
revenue_factor = #                            ; Revenue tier
security_factor = #                           ; Security measures
travel_factor = #                             ; Travel frequency
type_factor = #                               ; Organization type

{@kr_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@kr_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    assault,                                  ; Assault
    cyber_extortion,                          ; Cyber extortion
    detention,                                ; Wrongful detention
    disappearance,                            ; Disappearance
    express_kidnap,                           ; Express kidnap
    extortion,                                ; Extortion threat
    hijacking,                                ; Hijacking
    hostage,                                  ; Hostage situation
    kidnapping,                               ; Kidnapping
    product_extortion,                        ; Product extortion
    stalking,                                 ; Stalking
    threat,                                   ; Threat
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
captivity_days = ##                           ; Days in captivity
claim_id = :                                  ; Claim ID
claim_status = (
    active,
    closed,
    open,
    paid,
    reserved,
    resolved
)
consultant_used = ?                           ; Response consultant
country = :                                   ; Country of incident
crisis_costs = #$:(0..)                       ; Crisis response costs
deductible_applied = #$:(0..)                 ; Deductible
description = *:                              ; Description
incident_date = date                          ; Incident date
location = :                                  ; Location
outcome = (
    escaped,
    negotiated_release,
    paid_ransom,
    rescued,
    unresolved
)
ransom_amount = #$:(0..)                      ; Ransom paid
rehabilitation_costs = #$:(0..)               ; Rehab costs
reserve = #$:(0..)                            ; Reserve amount
victim_count = ##                             ; Number of victims

; ===================================================================================
; Kidnap and Ransom Policy
; ===================================================================================

{@kr_policy}
; Required fields first
coverage = !@kr_coverage                      ; K&R coverage terms
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
insured = !@kr_insured                        ; Insured organization
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
claims[] = @kr_claim                          ; Claims history
endorsements[] = :                            ; Policy endorsements
extortion = @kr_extortion                     ; Extortion coverage
id = :                                        ; Internal identifier
liability = @kr_liability                     ; Legal liability
policy_form = (
    corporate,                                ; Corporate policy
    family,                                   ; Family/HNWI policy
    travel                                    ; Travel-based policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending
)
premium = @kr_premium                         ; Premium details
producer = @producer                          ; Agent
response_firm = :                             ; Designated response firm
territory[] = :                               ; Covered territories
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
aggregate_limit = #$:(0..)                    ; Aggregate limit
covered_persons = ##                          ; Covered count
insured_name = :                              ; Organization name
per_person_limit = #$:(0..)                   ; Per person limit

{@kr_policy}


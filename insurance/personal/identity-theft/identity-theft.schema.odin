; ===================================================================================
; ODIN Identity Theft Insurance Schema
; ===================================================================================
; Identity theft insurance covering expense reimbursement, lost wages, legal
; fees, credit monitoring, fraud resolution services, and restoration of
; credit and identity records.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.identity-theft"
version = "1.0.0"
title = "Identity Theft Insurance Schema"
description = "Personal identity theft protection and cyber liability coverage"

{$derivation}
source[0].authority = "Federal Trade Commission (FTC)"
source[0].citation = "Identity Theft Reports and Consumer Protection Guidelines"
source[0].url = "https://www.ftc.gov/identity-theft"

source[1].authority = "National Association of Insurance Commissioners (NAIC)"
source[1].citation = "Identity Theft Insurance Model Regulation"
source[1].url = "https://content.naic.org/"

source[2].authority = "Insurance Information Institute"
source[2].citation = "Identity Theft Insurance Consumer Information"
source[2].url = "https://www.iii.org/article/what-identity-theft-insurance"

source[3].authority = "Consumer Financial Protection Bureau (CFPB)"
source[3].citation = "Identity Theft and Credit Reporting Guidelines"
source[3].url = "https://www.consumerfinance.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on FTC identity theft guidelines and NAIC model regulations"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial identity theft insurance schema"
changelog[0].rationale = "Personal lines coverage for identity theft and cyber protection"

; ===================================================================================
; Identity Theft Event Type
; ===================================================================================
; Classification of identity theft incidents.

{@idt_event_type}
event_category = !(
    account_takeover,                         ; Existing account compromise
    credit_fraud,                             ; New credit opened fraudulently
    criminal_identity,                        ; Identity used in crimes
    driver_license_fraud,                     ; License misuse
    employment_fraud,                         ; False employment using identity
    government_benefits_fraud,                ; Benefits fraud
    mail_theft,                               ; Mail-based identity theft
    medical_identity,                         ; Medical records/insurance fraud
    new_account_fraud,                        ; New accounts opened
    phishing,                                 ; Phishing attack
    ransomware,                               ; Ransomware attack
    social_media_compromise,                  ; Social media hijacking
    synthetic_identity,                       ; Fabricated identity using data
    tax_fraud,                                ; Tax refund fraud
    utility_fraud                             ; Utility account fraud
)
event_description = :                         ; Additional details

; ===================================================================================
; Covered Person
; ===================================================================================
; Individuals covered under the policy.

{@idt_covered_person}
; Required fields first
name = !@person_name                          ; Person's name
relationship = !(
    child,                                    ; Minor child
    dependent,                                ; Other dependent
    domestic_partner,                         ; Domestic partner
    self,                                     ; Primary insured
    spouse                                    ; Spouse
)

; Optional fields
covered_since = date                          ; Coverage start date
date_of_birth = *date                         ; Date of birth (PII)
email = *@email                               ; Email address (PII)
minor = ?                                     ; Is minor child
person_id = :                                 ; Unique identifier
phone = *@phone                               ; Phone contact (PII)
ssn_last_four = *:(4)                         ; Last 4 of SSN (PII)

; ===================================================================================
; Credit Monitoring Service
; ===================================================================================
; Credit and identity monitoring services included.

{@idt_monitoring_service}
; Required fields first
service_type = !(
    credit_bureau_monitoring,                 ; Bureau monitoring
    credit_freeze_management,                 ; Freeze/thaw management
    credit_lock_service,                      ; Credit lock service
    credit_score_tracking,                    ; Score monitoring
    dark_web_monitoring,                      ; Dark web scanning
    data_breach_notification,                 ; Breach alerts
    financial_account_monitoring,             ; Account monitoring
    fraud_alert_management,                   ; Fraud alerts
    public_records_monitoring,                ; Public records watch
    social_media_monitoring,                  ; Social media protection
    social_security_monitoring                ; SSN monitoring
)

; Optional fields
bureaus_monitored[] = (equifax, experian, transunion)
frequency = (continuous, daily, monthly, weekly)
included = ?true                              ; Service included in policy
monthly_cost = #$:(0..)                       ; If additional cost
provider = :                                  ; Service provider name
reports_per_year = ##                         ; Annual reports available

; ===================================================================================
; Restoration Service
; ===================================================================================
; Identity restoration assistance services.

{@idt_restoration_service}
; Required fields first
service_category = !(
    affidavit_assistance,                     ; Fraud affidavit help
    case_management,                          ; Dedicated case manager
    credit_bureau_liaison,                    ; Bureau dispute assistance
    creditor_notification,                    ; Notify creditors
    document_replacement,                     ; Replace documents
    fraud_alert_placement,                    ; Place fraud alerts
    ftc_reporting,                            ; FTC report assistance
    government_agency_liaison,                ; Agency communications
    limited_poa,                              ; Limited power of attorney
    police_report_assistance,                 ; Police report help
    resolution_support                        ; General resolution
)

; Optional fields
availability = (
    business_hours,                           ; Business hours only
    extended_hours,                           ; Extended availability
    twenty_four_seven                         ; 24/7 availability
)
dedicated_specialist = ?                      ; Dedicated case specialist
included = ?true                              ; Included in coverage
max_hours = ##                                ; Maximum hours provided
response_time_hours = ##                      ; Guaranteed response time

; ===================================================================================
; Coverage Limits
; ===================================================================================
; Financial coverage limits for various expense categories.

{@idt_coverage_limits}
; Required fields first
aggregate_limit = !#$:(0..)                   ; Maximum total coverage

; Optional fields
attorney_fees_limit = #$:(0..)                ; Legal defense limit
child_identity_limit = #$:(0..)               ; Per-child limit
credit_monitoring_limit = #$:(0..)            ; Monitoring costs limit
cyber_extortion_limit = #$:(0..)              ; Ransom/extortion limit
data_breach_response_limit = #$:(0..)         ; Breach response limit
deductible = #$:(0..)                         ; Policy deductible
document_replacement_limit = #$:(0..)         ; Document costs limit
elderly_parent_limit = #$:(0..)               ; Elderly parent coverage
fraudulent_charges_limit = #$:(0..)           ; Fraud reimbursement
lost_wages_daily = #$:(0..)                   ; Daily lost wages max
lost_wages_limit = #$:(0..)                   ; Total lost wages max
mental_health_limit = #$:(0..)                ; Counseling coverage
per_event_limit = #$:(0..)                    ; Per-incident limit
restoration_costs_limit = #$:(0..)            ; Restoration expenses
stolen_funds_limit = #$:(0..)                 ; Stolen money coverage
travel_expense_limit = #$:(0..)               ; Travel to resolve

; ===================================================================================
; Waiting Period
; ===================================================================================
; Time requirements before coverage applies.

{@idt_waiting_period}
days = ##:(0..90)                             ; Waiting period in days
applies_to = (
    all_coverage,                             ; All coverages
    cyber_extortion,                          ; Cyber extortion only
    lost_wages,                               ; Lost wages only
    stolen_funds                              ; Stolen funds only
)
waived_for_existing_customer = ?              ; Waived for renewals

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard policy exclusions.

{@idt_exclusions}
; Standard exclusions
business_identity = ?true                     ; Business identity theft
criminal_acts = ?true                         ; Insured's criminal acts
family_member_fraud = ?                       ; Fraud by family
intentional_acts = ?true                      ; Intentional disclosure
known_conditions = ?true                      ; Pre-existing incidents
pre_existing = ?true                          ; Pre-policy incidents
voluntary_disclosure = ?true                  ; Voluntary data sharing
war_terrorism = ?true                         ; War and terrorism

; Optional exclusions
cryptocurrency = ?                            ; Crypto losses excluded
investment_losses = ?                         ; Investment fraud
online_gambling = ?                           ; Gambling losses
romance_scams = ?                             ; Romance fraud

; ===================================================================================
; Identity Theft Event (Claim)
; ===================================================================================
; Records an identity theft incident and claim.

{@idt_event}
; Required fields first
date_discovered = !date                       ; Date incident discovered
event_type = !@idt_event_type                 ; Type of incident

; Optional fields
accounts_affected[] = :                       ; Affected account names
amount_at_risk = #$:(0..)                     ; Potential financial exposure
case_manager = :                              ; Assigned case manager
covered_person = @idt_covered_person          ; Person affected
credit_bureaus_notified = ?                   ; Bureaus notified flag
date_occurred = date                          ; Estimated occurrence date
date_reported = date                          ; Date reported to carrier
description = :                               ; Incident description
event_id = :                                  ; Unique event identifier
event_status = (
    active_restoration,                       ; Restoration in progress
    closed_resolved,                          ; Successfully resolved
    closed_unresolved,                        ; Closed without resolution
    denied,                                   ; Claim denied
    new,                                      ; New incident
    pending_documents,                        ; Awaiting documentation
    under_investigation                       ; Being investigated
)
ftc_report_number = :                         ; FTC report number
law_enforcement_notified = ?                  ; Police notified flag
law_enforcement_report = :                    ; Police report number
source_of_breach = (
    data_breach,                              ; Company data breach
    device_theft,                             ; Device stolen
    dumpster_diving,                          ; Mail/trash theft
    insider_threat,                           ; Known person
    mail_theft,                               ; Mail interception
    online_compromise,                        ; Online breach
    phishing,                                 ; Phishing attack
    physical_theft,                           ; Documents stolen
    skimming,                                 ; Card skimming
    social_engineering,                       ; Social engineering
    unknown                                   ; Unknown source
)

; ---------------------------------------------------------------------------
; Financial Impact
; ---------------------------------------------------------------------------
{.financial_impact}
attorney_fees = #$:(0..)                      ; Legal costs incurred
credit_repair_costs = #$:(0..)                ; Credit repair expenses
document_replacement = #$:(0..)               ; Document costs
fraudulent_charges = #$:(0..)                 ; Fraudulent amounts
lost_wages = #$:(0..)                         ; Wages lost
mental_health_costs = #$:(0..)                ; Counseling costs
other_expenses = #$:(0..)                     ; Other out-of-pocket
stolen_funds = #$:(0..)                       ; Money stolen
total_exposure = #$:(0..)                     ; Total financial impact
travel_expenses = #$:(0..)                    ; Travel costs

{@idt_event}

; ---------------------------------------------------------------------------
; Resolution Status
; ---------------------------------------------------------------------------
{.resolution}
accounts_recovered = ##                       ; Accounts restored
accounts_still_affected = ##                  ; Remaining affected
credit_restored = ?                           ; Credit fully restored
date_resolved = date                          ; Resolution date
documents_replaced[] = :                      ; Documents replaced
hours_spent = #                               ; Hours on resolution
resolution_notes = :                          ; Resolution details

{@idt_event}

; ---------------------------------------------------------------------------
; Claim Payment
; ---------------------------------------------------------------------------
{.claim_payment}
amount_approved = #$:(0..)                    ; Approved claim amount
amount_denied = #$:(0..)                      ; Denied portion
amount_paid = #$:(0..)                        ; Amount paid out
deductible_applied = #$:(0..)                 ; Deductible amount
denial_reason = :                             ; Reason if denied
payment_date = date                           ; Date of payment
payment_method = (ach, check, wire)           ; Payment method

{@idt_event}

; ===================================================================================
; Premium Details
; ===================================================================================
; Rating and premium information.

{@idt_premium}
; Required fields first
annual_premium = !#$:(0..)                    ; Annual premium amount

; Optional fields
child_premium = #$:(0..):if family_coverage = true
credit_monitoring_fee = #$:(0..)              ; Monitoring service fee
elderly_parent_premium = #$:(0..)             ; Parent coverage premium
family_coverage = ?                           ; Family plan flag
payment_frequency = (annual, monthly, quarterly, semi_annual)
per_person = #$:(0..)                         ; Per-person premium
policy_fee = #$:(0..)                         ; Policy fee
taxes_and_fees = #$:(0..)                     ; State taxes/fees

; ===================================================================================
; Endorsements
; ===================================================================================
; Policy endorsements and riders.

{@idt_endorsement}
; Required fields first
effective_date = !date                        ; Effective date
endorsement_type = !(
    child_protection,                         ; Child identity coverage
    cyber_extortion,                          ; Ransomware coverage
    elderly_parent,                           ; Parent coverage
    enhanced_monitoring,                      ; Premium monitoring
    limit_increase,                           ; Higher limits
    other,                                    ; Other endorsement
    social_media,                             ; Social media protection
    stolen_funds                              ; Electronic funds coverage
)

; Optional fields
additional_premium = #$:(0..)                 ; Premium impact
description = :                               ; Endorsement description
endorsement_id = :                            ; Endorsement identifier
expiration_date = date                        ; Expiration if temporary

; ===================================================================================
; Identity Theft Insurance Policy
; ===================================================================================
; Complete policy structure.

{@identity_theft_policy}
; Required fields first
coverage_limits = !@idt_coverage_limits       ; Coverage limits
effective_date = !date                        ; Policy effective date
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number
primary_insured = !@idt_covered_person        ; Primary insured

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
billing_address = @address                    ; Billing address
covered_persons[] = @idt_covered_person       ; Additional covered persons
endorsements[] = @idt_endorsement             ; Policy endorsements
events[] = @idt_event                         ; Identity theft events
exclusions = @idt_exclusions                  ; Policy exclusions
id = :                                        ; Internal identifier
monitoring_services[] = @idt_monitoring_service ; Monitoring services
policy_form = (
    homeowners_endorsement,                   ; HO policy endorsement
    renters_endorsement,                      ; Renters endorsement
    standalone                                ; Standalone policy
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @idt_premium                        ; Premium details
producer = @producer                          ; Producing agent
restoration_services[] = @idt_restoration_service ; Resolution services
state_province = :(2)                         ; Issuing state/province
term_months = ##:(1..12)                      ; Policy term
underwriting = @underwriting_decision         ; Underwriting decision
waiting_periods[] = @idt_waiting_period       ; Waiting periods

; ---------------------------------------------------------------------------
; Coverage Summary
; ---------------------------------------------------------------------------
{.coverage_summary}
aggregate_limit = #$:(0..)                    ; Total available coverage
covered_person_count = ##                     ; Number of covered persons
deductible = #$:(0..)                         ; Policy deductible
monitoring_included = ?                       ; Monitoring included flag
restoration_included = ?                      ; Restoration included flag

{@identity_theft_policy}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Commercial Crime and Fidelity Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial crime and fidelity insurance covering employee dishonesty, forgery,
; theft, computer fraud, funds transfer fraud, and fidelity bonds including
; commercial blanket and financial institution bonds.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.crime-fidelity"
version = "1.0.0"
title = "Commercial Crime and Fidelity Insurance Schema"
description = "Comprehensive crime coverage and fidelity bonds"

{$derivation}
source[0].authority = "Surety & Fidelity Association of America"
source[0].citation = "Commercial Crime and Fidelity Standards"
source[0].url = "https://www.surety.org/"

source[1].authority = "U.S. Department of the Treasury"
source[1].citation = "Financial Crimes Enforcement Network"
source[1].url = "https://www.fincen.gov/"

source[2].authority = "National Association of Insurance Commissioners (NAIC)"
source[2].citation = "Crime Insurance Model Laws"
source[2].url = "https://content.naic.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete crime schema covering all crime forms and fidelity bonds"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial crime/fidelity schema"
changelog[0].rationale = "Comprehensive crime coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; Crime Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@crime_coverage}
coverage_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form A - Employee Dishonesty
; ───────────────────────────────────────────────────────────────────────────────
{.employee_dishonesty}
included = ?
limit = #$:if employee_dishonesty.included = true
deductible = ##:if employee_dishonesty.included = true
coverage_form = (
    blanket,                                  ; All employees covered
    name_schedule,                            ; Scheduled by name
    position_schedule                         ; Scheduled by position
):if employee_dishonesty.included = true

; ERISA Coverage (employee benefit plans)
erisa_included = ?:if employee_dishonesty.included = true
erisa_plans_covered[] = ::if employee_dishonesty.erisa_included = true

; Temporary employees, contractors
temporary_employees = ?:if employee_dishonesty.included = true
leased_employees = ?:if employee_dishonesty.included = true
independent_contractors = ?:if employee_dishonesty.included = true
volunteers = ?:if employee_dishonesty.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form B - Forgery or Alteration
; ───────────────────────────────────────────────────────────────────────────────
{.forgery}
included = ?
limit = #$:if forgery.included = true
deductible = ##:if forgery.included = true
outgoing_instruments = ?:if forgery.included = true
incoming_instruments = ?:if forgery.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form C - Inside the Premises (Theft, Disappearance, Destruction)
; ───────────────────────────────────────────────────────────────────────────────
{.inside_premises}
included = ?
money_limit = #$:if inside_premises.included = true
securities_limit = #$:if inside_premises.included = true
other_property_limit = #$:if inside_premises.included = true
deductible = ##:if inside_premises.included = true
safe_burglary = ?:if inside_premises.included = true
robbery = ?:if inside_premises.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form D - Outside the Premises (Theft, Disappearance, Destruction)
; ───────────────────────────────────────────────────────────────────────────────
{.outside_premises}
included = ?
money_limit = #$:if outside_premises.included = true
securities_limit = #$:if outside_premises.included = true
other_property_limit = #$:if outside_premises.included = true
deductible = ##:if outside_premises.included = true
messenger = ?:if outside_premises.included = true
armored_car = ?:if outside_premises.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form E - Computer Fraud
; ───────────────────────────────────────────────────────────────────────────────
{.computer_fraud}
included = ?
limit = #$:if computer_fraud.included = true
deductible = ##:if computer_fraud.included = true
electronic_data = ?:if computer_fraud.included = true
computer_programs = ?:if computer_fraud.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form F - Funds Transfer Fraud
; ───────────────────────────────────────────────────────────────────────────────
{.funds_transfer}
included = ?
limit = #$:if funds_transfer.included = true
deductible = ##:if funds_transfer.included = true
fraudulent_instructions = ?:if funds_transfer.included = true
voice_initiated = ?:if funds_transfer.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Social Engineering
; ───────────────────────────────────────────────────────────────────────────────
{.social_engineering}
included = ?
limit = #$:if social_engineering.included = true
deductible = ##:if social_engineering.included = true
vendor_impersonation = ?:if social_engineering.included = true
client_impersonation = ?:if social_engineering.included = true
executive_impersonation = ?:if social_engineering.included = true
callback_verification_required = ?:if social_engineering.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Form G - Money Orders and Counterfeit Currency
; ───────────────────────────────────────────────────────────────────────────────
{.counterfeit}
included = ?
limit = #$:if counterfeit.included = true
deductible = ##:if counterfeit.included = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Crime Coverages
; ───────────────────────────────────────────────────────────────────────────────
{.additional}
kidnap_ransom = ?
kidnap_ransom_limit = #$:if additional.kidnap_ransom = true

extortion = ?
extortion_limit = #$:if additional.extortion = true

client_property = ?
client_property_limit = #$:if additional.client_property = true

credit_card_forgery = ?
credit_card_limit = #$:if additional.credit_card_forgery = true

{@crime_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Policy Aggregate
; ───────────────────────────────────────────────────────────────────────────────
policy_aggregate = #$
single_loss_limit = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Fidelity Bond (Alternative Structure)
; ═══════════════════════════════════════════════════════════════════════════════

{@fidelity_bond}
bond_id = !:
bond_type = !(
    blanket_position_bond,                    ; BPB - Per Position
    broker_dealer_blanket_bond,               ; FINRA requirement
    commercial_blanket_bond,                  ; CBB - Discovery Form
    financial_institution_bond_24,            ; Banks - Standard Form 24
    financial_institution_bond_25,            ; Investment firms
    government_crime,
    name_schedule_bond,                       ; Scheduled employees
    non_profit_crime,
    position_schedule_bond                    ; Scheduled positions
)
penalty = !#$                  ; Bond penalty amount

; ───────────────────────────────────────────────────────────────────────────────
; Bond Amount
; ───────────────────────────────────────────────────────────────────────────────
per_occurrence = #$
per_employee = #$:if bond_type = blanket_position_bond
deductible = ##

; ───────────────────────────────────────────────────────────────────────────────
; Covered Persons
; ───────────────────────────────────────────────────────────────────────────────
{.covered_persons}
employees = ?true
directors = ?
officers = ?
trustees = ?
partners = ?
temporary_employees = ?
volunteers = ?
independent_contractors = ?

{@fidelity_bond}

; Employee Count
employee_count = ##

; ───────────────────────────────────────────────────────────────────────────────
; Discovery Period
; ───────────────────────────────────────────────────────────────────────────────
discovery_form = ?                            ; Discovery vs Loss Sustained
loss_sustained_form = ?
discovery_period_months = ##:(12, 24, 36, 60):if discovery_form = true

; ═══════════════════════════════════════════════════════════════════════════════
; Crime Risk Profile
; ═══════════════════════════════════════════════════════════════════════════════

{@crime_exposure}
exposure_id = :

; ───────────────────────────────────────────────────────────────────────────────
; Cash Handling
; ───────────────────────────────────────────────────────────────────────────────
{.cash}
maximum_on_premises = #$
average_on_premises = #$
in_safe = #$
outside_safe = #$
maximum_in_transit = #$
bank_deposits_daily = #$

{@crime_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Securities Handling
; ───────────────────────────────────────────────────────────────────────────────
{.securities}
maximum_on_premises = #$
average_on_premises = #$
in_vault = #$
bearer_instruments = ?
registered_instruments = ?

{@crime_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Controls
; ───────────────────────────────────────────────────────────────────────────────
{.controls}
dual_signatures_required = ?
dual_signature_threshold = #$:if controls.dual_signatures_required = true
separation_of_duties = ?
background_checks = ?
background_check_scope = (both, credit, criminal):if controls.background_checks = true
internal_audit = ?
external_audit = ?
reconciliation_frequency = (daily, monthly, quarterly, weekly)
vault_alarm = ?
vault_time_lock = ?
armored_car_service = ?

{@crime_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Wire Transfer Controls
; ───────────────────────────────────────────────────────────────────────────────
{.wire}
callback_verification = ?
dual_authorization = ?
authorization_threshold = #$:if wire.dual_authorization = true
daily_wire_limit = #$
average_daily_wires = ##
average_wire_amount = #$

{@crime_exposure}

; ═══════════════════════════════════════════════════════════════════════════════
; Crime Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@crime_claims_history}
history_id = :

total_claims_5_years = ##
total_incurred_5_years = #$

{.claims[]}
claim_number = :
date_discovered = date
date_of_loss = date
loss_type = (
    burglary,
    computer_fraud,
    employee_dishonesty,
    forgery,
    funds_transfer,
    robbery,
    social_engineering,
    theft_inside,
    theft_outside,
    other
)
perpetrator = (collusion, employee, outsider, unknown)
status = (closed_no_payment, closed_paid, open)
paid_amount = #$
recovered = #$
reserves = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Crime Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@crime_policy}
id = !:
number = !:
effective_date = !date
expiration_date = !date
policy_form = !(
    discovery,                                ; Covers losses discovered during policy
    loss_sustained                            ; Covers losses occurring during policy
)

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_time = time
expiration_time = time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Form
; ───────────────────────────────────────────────────────────────────────────────

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @crime_coverage

; Fidelity Bond (if applicable)
fidelity_bond = @fidelity_bond

; ───────────────────────────────────────────────────────────────────────────────
; Exposure
; ───────────────────────────────────────────────────────────────────────────────
exposure = @crime_exposure

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @location.business_location

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims_history = @crime_claims_history

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$
endorsements = #$
taxes_fees = #$
total = #$
minimum = #$

{@crime_policy}



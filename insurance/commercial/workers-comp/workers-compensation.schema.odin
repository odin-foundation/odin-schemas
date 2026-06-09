; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Workers' Compensation Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Workers' compensation insurance supporting national and independent bureau states
; including class codes, experience modification rating, USL&H/Longshore coverage,
; voluntary compensation, deductible, and retrospective rating programs.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/workers-comp.schema.odin" as wc
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.workers-comp"
version = "2.0.0"
title = "Workers' Compensation Insurance Schema"
description = "Comprehensive WC coverage extending universal coverage primitive"

{$derivation}
source[0].authority = "U.S. Department of Labor"
source[0].citation = "Longshore and Harbor Workers' Compensation Act"
source[0].url = "https://www.dol.gov/agencies/owcp/dlhwc"

source[1].authority = "U.S. Department of Labor"
source[1].citation = "Office of Workers' Compensation Programs"
source[1].url = "https://www.dol.gov/agencies/owcp"

source[2].authority = "Texas Department of Insurance"
source[2].citation = "Texas Workers' Compensation Classification Relativities"
source[2].url = "https://www.tdi.texas.gov/wc/index.html"

source[3].authority = "California Department of Industrial Relations"
source[3].citation = "Division of Workers' Compensation"
source[3].url = "https://www.dir.ca.gov/dwc/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "WC schema extending universal coverage primitive with comprehensive state support"

changelog[0].date = 2025-12-14
changelog[0].change = "Refactored to extend universal coverage primitive"
changelog[0].rationale = "Coverage-centric architecture - extend @wc_coverage from coverage/lines/workers-comp.schema.odin"

changelog[1].date = 2025-12-13
changelog[1].change = "Initial WC schema"
changelog[1].rationale = "Comprehensive workers' compensation coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; WC Classification (Class Code Detail)
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_classification}
= @rating_classification                      ; Use shared rating classification type

id = :
sequence = ##:(1..)

; ───────────────────────────────────────────────────────────────────────────────
; Classification Code - extends @rating_classification
; ───────────────────────────────────────────────────────────────────────────────
; class_code and class_description are inherited from @rating_classification
phraseology = :                        ; Short name

; Code Type
code_type = (
    exception,                                ; Exception to governing
    governing,                                ; Governing class for policy
    if_any,                                   ; If any operations class
    special,
    standard,
    standard_exception                        ; 8810 Clerical, 8742 Sales, etc.
)

; Bureau
rating_bureau = (
    dcrb_de,                                  ; Delaware
    ncci,
    nd_wsi,                                   ; North Dakota (monopolistic)
    njcrib,                                   ; New Jersey
    nycirb,                                   ; New York
    oh_bwc,                                   ; Ohio (monopolistic)
    pcrb_pa,                                  ; Pennsylvania
    tdi_tx,                                   ; Texas
    wa_lni,                                   ; Washington (monopolistic)
    wcirb_ca,                                 ; California
    wy_dws                                    ; Wyoming (monopolistic)
)

; ───────────────────────────────────────────────────────────────────────────────
; Exposure - extends @rating_classification exposure fields
; ───────────────────────────────────────────────────────────────────────────────
exposure_basis_description = ::if exposure_basis = other

estimated_annual_payroll = #$
estimated_employee_count = ##

; Actual (audit)
audited_payroll = #$
audited_employee_count = ##

; Payroll period (if not full policy period)
payroll_period = date_range

; ───────────────────────────────────────────────────────────────────────────────
; Rate and Premium - extends @rating_classification base_rate and factor
; ───────────────────────────────────────────────────────────────────────────────
manual_rate = #:(0..999.999999)               ; Per $100 payroll

; Loss cost state indicator
loss_cost_state = ?                           ; Is this a loss cost state?
loss_cost_multiplier = #:(0..):if loss_cost_state = true

; Premium calculations
manual_premium = #$
modified_premium = #$          ; After experience mod
standard_premium = #$          ; After schedule mod
estimated_annual_premium = #$

; ───────────────────────────────────────────────────────────────────────────────
; Location Assignment
; ───────────────────────────────────────────────────────────────────────────────
location_number = ##:(1..)                    ; Which location
state = :(2)                                 ; State for this classification
territory = :                           ; Rating territory

; ───────────────────────────────────────────────────────────────────────────────
; Operations Description
; ───────────────────────────────────────────────────────────────────────────────
operations_description = :
duties_performed = :
equipment_used[] = :
materials_handled[] = :

; Special classifications
subcontracted_work = ?
subcontractor_percentage = ##:(0..100):if subcontracted_work = true
temporary_staffing = ?
leased_employees = ?

; ═══════════════════════════════════════════════════════════════════════════════
; WC Commercial State Coverage (Extends @wc_coverage from line)
; ═══════════════════════════════════════════════════════════════════════════════
; Inherits from @wc_coverage which inherits from @coverage (universal primitive)

{@wc_commercial_state_coverage}
= @wc_coverage                                    ; Inherit from WC line extension

id = :

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Status
; ───────────────────────────────────────────────────────────────────────────────
coverage_status = (
    covered,
    excluded,
    if_any,                                       ; Coverage "if any" operations
    monopolistic_fund,                            ; State fund only
    pending
)

; Monopolistic state fund info
state_fund_policy_number = ::if coverage_status = monopolistic_fund
state_fund_effective_date = date:if coverage_status = monopolistic_fund

; ───────────────────────────────────────────────────────────────────────────────
; Part One - Workers' Compensation (Statutory)
; ───────────────────────────────────────────────────────────────────────────────
{.part_one}
coverage = ?true                                  ; WC statutory benefits
benefits = (scheduled, statutory)
state_act = :                              ; Applicable state act
benefit_waiting_period_days = ##
max_temporary_disability_weeks = ##
max_permanent_partial_weeks = ##
death_benefit_max = #$

{@wc_commercial_state_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Part Two - Employer's Liability
; ───────────────────────────────────────────────────────────────────────────────
{.part_two}
bodily_injury_each_accident = #$
bodily_injury_by_disease_employee = #$
bodily_injury_by_disease_aggregate = #$

; Increased limits
increased_limits = ?
increased_limits_factor = #:(1..):if increased_limits = true

{@wc_commercial_state_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; State-Specific Requirements
; ───────────────────────────────────────────────────────────────────────────────
; Managed Care
{.managed_care}
enrolled = ?
organization = ::if enrolled = true
network = ::if enrolled = true
credit = #:(..0):if enrolled = true

{@wc_commercial_state_coverage}

; Drug-Free Workplace
drug_free_workplace = ?
drug_free_workplace_credit = #:(..0):if drug_free_workplace = true

; Safety Program
certified_safety_program = ?
safety_program_credit = #:(..0):if certified_safety_program = true

; Premium Discount Program
premium_discount_tier = ##:(1..)
premium_discount_percentage = #:(..0)

; ───────────────────────────────────────────────────────────────────────────────
; State Premium Tax/Assessment
; ───────────────────────────────────────────────────────────────────────────────
state_assessment_rate = #:(0..)
second_injury_fund_rate = #:(0..)
special_fund_rate = #:(0..)
terrorism_fund_rate = #:(0..)

; ───────────────────────────────────────────────────────────────────────────────
; Classifications for this State
; ───────────────────────────────────────────────────────────────────────────────
classifications[] = @wc_classification

; State-level totals
total_estimated_payroll = #$
total_estimated_premium = #$

; ═══════════════════════════════════════════════════════════════════════════════
; Experience Modification
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_experience_mod}
id = :

; ───────────────────────────────────────────────────────────────────────────────
; Modification Factor
; ───────────────────────────────────────────────────────────────────────────────
modification_factor = #:(0.10..5.00)          ; The X-Mod (1.00 = unity)
effective_date = date
expiration_date = date

; Rating Bureau
rating_bureau = (
    dcrb_de,
    ncci,
    njcrib,
    nycirb,
    other,
    pcrb_pa,
    wcirb_ca
)
bureau_other_name = ::if rating_bureau = other

; Risk ID
risk_id = :                             ; Bureau-assigned risk ID
risk_type = (combinable, interstate, single_entity)

; ───────────────────────────────────────────────────────────────────────────────
; Rating Period
; ───────────────────────────────────────────────────────────────────────────────
experience_period_start = date
experience_period_end = date

; Policy years included
{.policy_years[]}
year = ##:(2000..2100)
effective_date = date
expiration_date = date
policy_number = :
carrier = :

{@wc_experience_mod}

; ───────────────────────────────────────────────────────────────────────────────
; Exposure (Used in Calculation)
; ───────────────────────────────────────────────────────────────────────────────
expected_losses = #$
expected_primary_losses = #$
expected_excess_losses = #$

; Actual experience
actual_losses = #$
actual_primary_losses = #$
actual_excess_losses = #$

; Ballast value (D-ratio)
ballast_value = #$
weighting_value = #:(0..1)

; ───────────────────────────────────────────────────────────────────────────────
; Claims in Experience Period
; ───────────────────────────────────────────────────────────────────────────────
total_claims = ##
open_claims = ##
medical_only_claims = ##
lost_time_claims = ##
fatality_claims = ##

; Individual large losses
{.large_losses[]}
date = date
type = (fatality, indemnity, medical)
actual_amount = #$
capped_amount = #$

{@wc_experience_mod}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (
    assigned,
    contested,
    estimated,
    pending,
    revised
)

; For contested mods
contested_reason = ::if status = contested
revised_mod = #:(0.10..5.00):if status = revised
revision_date = date:if status = revised

; ═══════════════════════════════════════════════════════════════════════════════
; Schedule Rating / Merit Rating
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_schedule_rating}
id = :
effective_date = date

; Overall modification
total_credit = #:(-40..0)
total_debit = #:(0..40)
net_modification = #:(-40..40)

; Rating Categories (Schedule Rating Plan)
{.premises}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

{.classification}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

{.medical_facilities}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

{.safety_devices}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

{.employees}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

{.management}
credit = #:(..0)
debit = #:(0..)
description = :

{@wc_schedule_rating}

; Underwriter assigned
underwriter_name = :
underwriter_notes = :

; ═══════════════════════════════════════════════════════════════════════════════
; USL&H Coverage (Longshore and Harbor Workers)
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_uslh_coverage}
id = :

; Coverage type
type = (
    dcba,                                     ; Defense Base Act
    fela,                                     ; Federal Employers Liability Act (Railroad)
    jones_act,                                ; Maritime / Seamen
    ocsla,                                    ; Outer Continental Shelf Lands Act
    uslh                                      ; Longshore & Harbor Workers
)

; Limits (Jones Act / FELA)
per_occurrence_limit = ##:if type = jones_act
aggregate_limit = ##:if type = jones_act

; Exposure
estimated_remuneration = #$
employee_count = ##

; Classifications
classifications[] = :(4..5)                   ; USL&H class codes

; Premium
manual_premium = #$
experience_mod_factor = #:(0.10..5.00)
modified_premium = #$

; Status
status = (active, excluded, pending)

; ═══════════════════════════════════════════════════════════════════════════════
; Voluntary Compensation
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_voluntary_comp}
id = :

; Covered persons
covered_persons = (
    corporate_officers,
    domestic_workers,
    exempt_employees,
    farm_workers,
    llc_members,
    other,
    partners,
    real_estate_agents,
    sole_proprietors
)
covered_persons_description = ::if covered_persons = other

; Benefits
benefits_level = (limited, scheduled, statutory)
scheduled_benefits = ::if benefits_level = scheduled

; Exposure
person_count = ##:(1..)
estimated_remuneration = #$

; Premium
premium = #$

; Status
status = (active, excluded)

; ═══════════════════════════════════════════════════════════════════════════════
; Foreign Voluntary WC
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_foreign_voluntary}
id = :

; Countries covered
countries[] = :
worldwide = ?

; Excluded countries
excluded_countries[] = :

; Coverage basis
coverage_basis = (
    difference_in_conditions,
    full_coverage,
    statutory_equivalent
)

; Limits
limit_per_occurrence = ##
limit_aggregate = ##
repatriation_limit = ##

; Exposure
estimated_employee_days = ##
estimated_premium = #$

; Status
status = (active, excluded)

; ═══════════════════════════════════════════════════════════════════════════════
; Deductible Programs
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_deductible}
id = :

; Deductible Type
type = (
    aggregate,
    per_accident,
    per_claim_combined,
    per_claim_indemnity,
    per_claim_medical
)

; Amount
amount = ##
aggregate_limit = ##:if type != aggregate

; Application
applies_to = (both, indemnity_only, medical_only)

; Credit
premium_credit = #:(..0)

; Reimbursement
reimbursement_type = (deductible, self_insured_retention)
collateral_required = ?
collateral_amount = #$:if collateral_required = true
collateral_type = (cash, letter_of_credit, surety_bond, trust):if collateral_required = true

; ═══════════════════════════════════════════════════════════════════════════════
; Retrospective Rating
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_retrospective}
id = :

; Plan Type
plan_type = (
    combination,
    incurred_loss,
    paid_loss
)

; Rating Values
basic_premium_factor = #:(0..1)               ; % of standard premium
tax_multiplier = #:(1..1.5)
loss_conversion_factor = #:(1..2)

; Limits
minimum_premium = #$
maximum_premium = #$
loss_limitation = #$

; Expected losses
expected_loss_ratio = #:(0..2)

; Development
development_period_years = ##:(1..)
adjustment_dates[] = date

; Collateral
collateral_required = ?
collateral_amount = #$:if collateral_required = true
collateral_form = (cash_deposit, letter_of_credit, surety_bond):if collateral_required = true

; ═══════════════════════════════════════════════════════════════════════════════
; Officer/Partner Inclusion/Exclusion
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_officer_status}
id = :

; Identity
{.name}
first = :
middle = :
last = :
suffix = :

{@wc_officer_status}

; Title
title = :
ownership_percentage = #:(0..100)

; Status
status = (excluded, included)
status_election_date = date
state_province = :(2)                         ; US state or Canadian province for this election

; If included
class_code = :(4..5):if status = included
estimated_remuneration = #$:if status = included
payroll_cap = #$:if status = included      ; Many states cap officer payroll
payroll_minimum = #$:if status = included  ; Many states have minimum

; Exclusion form
exclusion_form_number = ::if status = excluded
exclusion_form_date = date:if status = excluded

; ═══════════════════════════════════════════════════════════════════════════════
; WC Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_endorsement}
id = :
number = :                 ; WC 00 03 01, etc.
title = :
edition_date = date
effective_date = date

; Type
type = (
    ; Coverage modifications
    aircraft_exclusion,
    all_states,
    alternate_employer,
    catastrophe_limitations,
    deductible,
    experience_rating_modification,
    foreign_voluntary_compensation,
    information_page,
    joint_venture,
    longshore_coverage,
    other,
    other_states_insurance,
    premium_discount,
    retrospective_rating,
    schedule_rating,
    sole_proprietor_partner_exclusion,
    ; State-specific
    state_amendatory,
    state_elective,
    state_mandatory,
    ; Other
    voluntary_compensation,
    waiver_of_subrogation
)

; Description
description = :
premium_impact = #$

; ═══════════════════════════════════════════════════════════════════════════════
; WC Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@wc_policy}
id = :
number = :

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date
effective_time = time
expiration_date = date
expiration_time = time
:invariant expiration_date > effective_date

; Policy type
type = (assigned_risk, new, renewal, rewrite)

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business

; ───────────────────────────────────────────────────────────────────────────────
; States Covered
; ───────────────────────────────────────────────────────────────────────────────
; Part 3A - States where coverage applies
covered_states[] = :(2)

; Part 3C - All States Endorsement (except monopolistic)
all_states_endorsement = ?
excluded_states[] = :(2):if all_states_endorsement = true

; State-specific coverage details (uses new coverage architecture)
state_coverage[] = @wc_commercial_state_coverage

; ───────────────────────────────────────────────────────────────────────────────
; Experience Modification
; ───────────────────────────────────────────────────────────────────────────────
experience_mod = @wc_experience_mod

; Schedule Rating
schedule_rating = @wc_schedule_rating

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @location.business_location

; ───────────────────────────────────────────────────────────────────────────────
; Officers / Partners / Members
; ───────────────────────────────────────────────────────────────────────────────
officer_status[] = @wc_officer_status

; ───────────────────────────────────────────────────────────────────────────────
; Special Coverages
; ───────────────────────────────────────────────────────────────────────────────
; USL&H / Maritime
uslh_coverage = @wc_uslh_coverage

; Voluntary Compensation
voluntary_comp[] = @wc_voluntary_comp

; Foreign Coverage
foreign_voluntary = @wc_foreign_voluntary

; ───────────────────────────────────────────────────────────────────────────────
; Rating Programs
; ───────────────────────────────────────────────────────────────────────────────
; Deductible
deductible = @wc_deductible

; Retrospective Rating
retrospective = @wc_retrospective

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @wc_endorsement

; ───────────────────────────────────────────────────────────────────────────────
; Audit Information
; ───────────────────────────────────────────────────────────────────────────────
audit_type = (annual, monthly, quarterly, self_audit, semi_annual)
audit_due_date = date
estimated_annual_audit = ?

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
manual = #$
experience_modified = #$
schedule_modified = #$
standard = #$
discount = #$                  ; Premium discount
expense_constant = #$
state_assessments = #$
terrorism = #$
catastrophe = #$
total_estimated = #$
minimum = #$
deposit = #$



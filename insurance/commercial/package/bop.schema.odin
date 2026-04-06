; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Business Owners Policy (BOP) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Business Owners Policy (BOP) package combining property and liability coverage
; for small to medium-sized businesses including building, business personal
; property, business income, and CGL-equivalent liability.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.package.bop"
version = "1.0.0"
title = "Business Owners Policy Schema"
description = "Comprehensive BOP coverage for small/medium businesses"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "Commercial Package Policy Filing Requirements"
source[0].url = "https://www.tdi.texas.gov/commercial/index.html"

source[1].authority = "U.S. Small Business Administration"
source[1].citation = "Small Business Insurance Requirements"
source[1].url = "https://www.sba.gov/business-guide/launch-your-business/get-business-insurance"

source[2].authority = "California Department of Insurance"
source[2].citation = "Commercial Package Policy Regulations"
source[2].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "BOP schema based on state regulatory requirements for package policies"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial BOP schema"
changelog[0].rationale = "Comprehensive package policy coverage structure"

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Classification
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_classification}
id = :                                        ; Unique classification identifier

; BOP Classification
class_code = !:                         ; BOP class code
class_description = !:                        ; Description of the class code
class_group = (                              ; Business classification category
    apartment,
    condominium,
    contractor,
    office,
    other,
    processing,
    restaurant,
    retail,
    service,
    wholesale
)

; Eligibility
eligible = ?                                  ; Meets BOP eligibility requirements
ineligibility_reason = ::if eligible = false  ; Reason for ineligibility if applicable

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Location Coverage
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_location}
id = :                                        ; Unique location identifier
location_number = ##                          ; Sequential location number for the policy

; ───────────────────────────────────────────────────────────────────────────────
; Location Details
; ───────────────────────────────────────────────────────────────────────────────
location_reference = @location.business_location   ; Reference to business location details
classification = @bop_classification          ; BOP classification for this location

; ───────────────────────────────────────────────────────────────────────────────
; Section I - Property Coverage
; ───────────────────────────────────────────────────────────────────────────────

; Building Coverage
{.building}
included = ?                                  ; Whether building coverage is included
limit = #$:(0..):if included = true           ; Building coverage limit
coinsurance = ##:(80, 90, 100):if included = true   ; Coinsurance percentage requirement
valuation = (actual_cash_value, replacement_cost):if included = true   ; Valuation basis for losses
agreed_value = ?:if included = true           ; Whether agreed value is used
agreed_value_amount = #$:(0..):if agreed_value = true   ; Agreed value amount if applicable
deductible = ##:(250, 500, 1000, 2500, 5000, 10000, 25000):if included = true   ; Building deductible amount

{@bop_location}
; Business Personal Property (Contents)
{.bpp}
included = ?                                  ; Whether BPP coverage is included
limit = #$:(0..):if included = true           ; Business personal property limit
coinsurance = ##:(80, 90, 100):if included = true   ; Coinsurance percentage requirement
valuation = (actual_cash_value, replacement_cost):if included = true   ; Valuation basis for BPP losses
seasonal_increase = ?:if included = true      ; Whether seasonal inventory increase applies
seasonal_percentage = ##:(0..50):if seasonal_increase = true   ; Seasonal increase percentage
deductible = ##:(250, 500, 1000, 2500, 5000, 10000, 25000):if included = true   ; BPP deductible amount

{@bop_location}
; Tenant's Improvements
{.tenant_improvements}
included = ?                                  ; Whether tenant improvements coverage is included
limit = #$:(0..):if included = true           ; Tenant improvements and betterments limit

{@bop_location}
; Personal Property of Others
{.ppo}
included = ?                                  ; Whether personal property of others coverage is included
limit = #$:(0..):if included = true           ; Personal property of others limit

{@bop_location}

; ───────────────────────────────────────────────────────────────────────────────
; Business Income and Extra Expense (Included in BOP)
; ───────────────────────────────────────────────────────────────────────────────
{.business_income}
included = ?true              ; Standard in BOP
limit = #$:(0..)                              ; Business income coverage limit
actual_loss_sustained = ?                     ; Whether actual loss sustained coverage applies
monthly_limit = #$:(0..):if actual_loss_sustained = true   ; Monthly limit if actual loss sustained
waiting_period_hours = ##:(0, 24, 48, 72)     ; Waiting period before coverage begins
extended_period_days = ##:(0, 30, 60, 90, 180)   ; Extended period of restoration in days

; Ordinary Payroll
ordinary_payroll = ?                          ; Whether ordinary payroll is covered
ordinary_payroll_days = ##:(0, 60, 90, 180):if ordinary_payroll = true   ; Days ordinary payroll is covered

{@bop_location}
; Extra Expense
{.extra_expense}
included = ?true                              ; Whether extra expense coverage is included
limit = #$:(0..)                              ; Extra expense coverage limit

{@bop_location}

; ───────────────────────────────────────────────────────────────────────────────
; Additional Property Coverages (Included in Standard BOP)
; ───────────────────────────────────────────────────────────────────────────────
{.additional_coverages}
debris_removal = #$:(0..)                     ; Debris removal coverage limit
preservation_of_property = #$:(0..)           ; Preservation of property limit
fire_department_service = #$:(0..)            ; Fire department service charge limit
pollutant_cleanup = #$:(0..)                  ; Pollutant cleanup and removal limit
money_and_securities = #$:(0..)               ; Money and securities limit
forgery_or_alteration = #$:(0..)              ; Forgery or alteration limit
outdoor_signs = #$:(0..)                      ; Outdoor signs coverage limit
valuable_papers = #$:(0..)                    ; Valuable papers and records limit
accounts_receivable = #$:(0..)                ; Accounts receivable limit
employee_dishonesty = #$:(0..)                ; Employee dishonesty coverage limit
mechanical_breakdown = ?                      ; Whether mechanical breakdown coverage is included
mechanical_breakdown_limit = #$:(0..):if mechanical_breakdown = true   ; Mechanical breakdown limit

{@bop_location}

; ───────────────────────────────────────────────────────────────────────────────
; Property Extensions
; ───────────────────────────────────────────────────────────────────────────────
{.extensions}
newly_acquired_property = ?true               ; Whether newly acquired property extension applies
newly_acquired_building_limit = #$:(0..)      ; Limit for newly acquired buildings
newly_acquired_bpp_limit = #$:(0..)           ; Limit for newly acquired business personal property
newly_acquired_days = ##:(30, 60, 90)         ; Days of automatic coverage for newly acquired property

off_premises_property = ?                     ; Whether off-premises property extension is included
off_premises_limit = #$:(0..):if off_premises_property = true   ; Off-premises property limit

outdoor_property = ?                          ; Whether outdoor property extension is included
outdoor_property_limit = #$:(0..):if outdoor_property = true   ; Outdoor property limit

personal_effects = ?                          ; Whether personal effects extension is included
personal_effects_limit = #$:(0..):if personal_effects = true   ; Personal effects limit

{@bop_location}

; ───────────────────────────────────────────────────────────────────────────────
; Location Rating
; ───────────────────────────────────────────────────────────────────────────────
{.rating}
territory = :                                 ; Rating territory code
protection_class = :                          ; Fire protection class
construction_class = :                        ; Building construction class
building_rate = #                             ; Rate per $100 for building coverage
contents_rate = #                             ; Rate per $100 for contents coverage

{@bop_location}
{.premium}
building = #$:(0..)                           ; Building coverage premium
bpp = #$:(0..)                                ; Business personal property premium
business_income = #$:(0..)                    ; Business income premium
total_location = #$:(0..)                     ; Total location premium

{@bop_location}

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Liability Coverage (Section II)
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_liability}
id = :                                        ; Unique liability coverage identifier

; ───────────────────────────────────────────────────────────────────────────────
; Occurrence Limits
; ───────────────────────────────────────────────────────────────────────────────
each_occurrence = !##                         ; Limit per occurrence
general_aggregate = !##                       ; General aggregate limit
products_completed_ops_aggregate = !##        ; Products and completed operations aggregate limit
personal_advertising_injury = ##              ; Personal and advertising injury limit
damage_to_premises_rented = ##                ; Damage to rented premises limit
medical_expense = ##                          ; Medical expense limit per person

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Territory
; ───────────────────────────────────────────────────────────────────────────────
territory = (us_territories_canada, worldwide)   ; Coverage territory

; ───────────────────────────────────────────────────────────────────────────────
; Products-Completed Operations
; ───────────────────────────────────────────────────────────────────────────────
{.products_completed_ops}
included = ?                                  ; Whether products-completed operations coverage is included
description = :                               ; Description of products or completed operations
annual_products_receipts = #$:(0..)           ; Annual gross receipts from products sold
annual_completed_ops_receipts = #$:(0..)      ; Annual receipts from completed operations

{@bop_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Hired/Non-Owned Auto
; ───────────────────────────────────────────────────────────────────────────────
{.hired_auto}
included = ?                                  ; Whether hired auto liability is included
limit = ##:if included = true                 ; Hired auto liability limit

{@bop_liability}
{.non_owned_auto}
included = ?                                  ; Whether non-owned auto liability is included
limit = ##:if included = true                 ; Non-owned auto liability limit

{@bop_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Employment Practices (Optional)
; ───────────────────────────────────────────────────────────────────────────────
{.employment_practices}
included = ?                                  ; Whether employment practices liability is included
limit = #$:(0..):if included = true           ; Employment practices liability limit
deductible = ##:if included = true            ; Employment practices liability deductible
retroactive_date = date:if included = true    ; Retroactive date for employment practices coverage

{@bop_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Professional Liability (Optional for certain classes)
; ───────────────────────────────────────────────────────────────────────────────
{.professional_liability}
included = ?                                  ; Whether professional liability is included
limit = ##:if included = true                 ; Professional liability limit
deductible = ##:if included = true            ; Professional liability deductible
retroactive_date = date:if included = true    ; Retroactive date for professional liability coverage

{@bop_liability}

; ───────────────────────────────────────────────────────────────────────────────
; Liability Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
liability_base = #$:(0..)                     ; Base liability premium
products_completed_ops = #$:(0..)             ; Products-completed operations premium
optional_coverages = #$:(0..)                 ; Optional liability coverages premium
total_liability = #$:(0..)                    ; Total liability premium

{@bop_liability}

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Additional Insured
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_additional_insured}
ai_id = :                                     ; Unique additional insured identifier

; Identity - uses shared @address type (US and Canada)
name = !:                                     ; Name of the additional insured
address = @address                            ; Address of the additional insured

{@bop_additional_insured}

; Endorsement Form
endorsement_form = !(                         ; Endorsement form used for additional insured
    blanket_automatic,
    bp_04_02_managers_lessors,
    bp_04_05_lessor_leased_equipment,
    bp_04_06_vendors,
    bp_04_47_designated_person_organization,
    bp_04_50_owners_lessees_contractors,
    custom
)

; Coverage Scope
coverage_scope = (                            ; Scope of coverage provided to additional insured
    both,
    completed_operations,
    ongoing_operations,
    premises,
    products
)

; Special Provisions
primary_and_noncontributory = ?               ; Whether coverage is primary and non-contributory
waiver_of_subrogation = ?                     ; Whether waiver of subrogation applies
notice_of_cancellation = ?                    ; Whether notice of cancellation is required
cancellation_notice_days = ##:if notice_of_cancellation = true   ; Days of notice required for cancellation

; Contract Reference
contract_number = :                           ; Contract or agreement number
contract_date = date                          ; Date of the contract
project_name = :                              ; Name of the project

; Effective Period
effective_date = date                         ; Effective date of additional insured coverage
expiration_date = date                        ; Expiration date of additional insured coverage

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Optional Coverages
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_optional_coverage}
id = :                                        ; Unique optional coverage identifier

; ───────────────────────────────────────────────────────────────────────────────
; Crime Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.crime}
included = ?                                  ; Whether crime coverage is included
employee_dishonesty_limit = ##:if included = true   ; Employee dishonesty coverage limit
money_securities_inside_limit = ##:if included = true   ; Inside premises money and securities limit
money_securities_outside_limit = ##:if included = true   ; Outside premises money and securities limit
forgery_limit = ##:if included = true         ; Forgery or alteration limit
computer_fraud_limit = ##:if included = true  ; Computer fraud coverage limit
deductible = ##:if included = true            ; Crime coverage deductible

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment Breakdown
; ───────────────────────────────────────────────────────────────────────────────
{.equipment_breakdown}
included = ?                                  ; Whether equipment breakdown coverage is included
limit = #$:(0..):if included = true           ; Equipment breakdown coverage limit
deductible = ##:if included = true            ; Equipment breakdown deductible
spoilage_limit = #$:(0..):if included = true  ; Spoilage coverage limit

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Earthquake Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.earthquake}
included = ?                                  ; Whether earthquake coverage is included
building_limit = #$:(0..):if included = true  ; Earthquake coverage limit for building
bpp_limit = #$:(0..):if included = true       ; Earthquake coverage limit for BPP
deductible_percentage = ##:(2, 5, 10, 15, 20, 25):if included = true   ; Earthquake deductible percentage
deductible_minimum = ##:if included = true    ; Minimum earthquake deductible amount

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Flood Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.flood}
included = ?                                  ; Whether flood coverage is included
building_limit = #$:(0..):if included = true  ; Flood coverage limit for building
bpp_limit = #$:(0..):if included = true       ; Flood coverage limit for BPP
deductible = ##:if included = true            ; Flood coverage deductible
waiting_period_hours = ##:(0, 24, 48, 72):if included = true   ; Flood waiting period in hours

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cyber Liability
; ───────────────────────────────────────────────────────────────────────────────
{.cyber}
included = ?                                  ; Whether cyber liability coverage is included
limit = #$:(0..):if included = true           ; Cyber liability coverage limit
deductible = ##:if included = true            ; Cyber liability deductible
retroactive_date = date:if included = true    ; Retroactive date for cyber coverage
data_breach_response = ?:if included = true   ; Whether data breach response is included
network_security = ?:if included = true       ; Whether network security liability is included

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Utility Services
; ───────────────────────────────────────────────────────────────────────────────
{.utility_services}
included = ?                                  ; Whether utility services coverage is included
direct_damage = ?:if included = true          ; Whether direct damage from utility failure is covered
time_element = ?:if included = true           ; Whether time element coverage is included
limit = #$:(0..):if included = true           ; Utility services coverage limit

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Liquor Liability
; ───────────────────────────────────────────────────────────────────────────────
{.liquor_liability}
included = ?                                  ; Whether liquor liability coverage is included
limit = ##:if included = true                 ; Liquor liability per occurrence limit
aggregate = ##:if included = true             ; Liquor liability aggregate limit

{@bop_optional_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Optional Coverage Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
crime = #$:(0..):if crime.included = true     ; Crime coverage premium
equipment_breakdown = #$:(0..):if equipment_breakdown.included = true   ; Equipment breakdown premium
earthquake = #$:(0..):if earthquake.included = true   ; Earthquake coverage premium
flood = #$:(0..):if flood.included = true     ; Flood coverage premium
cyber = #$:(0..):if cyber.included = true     ; Cyber liability premium
utility_services = #$:(0..):if utility_services.included = true   ; Utility services premium
liquor = #$:(0..):if liquor_liability.included = true   ; Liquor liability premium
total_optional = #$:(0..)                     ; Total optional coverages premium

{@bop_optional_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_endorsement}
id = :                                        ; Unique endorsement identifier
number = !:                 ; BP 04 XX
title = :                                     ; Endorsement title
edition_date = date                           ; Edition date of the endorsement form
effective_date = date                         ; Effective date of the endorsement

; Endorsement Type
type = (bp_04_02_managers_lessors, bp_04_05_lessor_leased_equipment, bp_04_06_vendors, bp_04_25_earthquake, bp_04_26_flood, bp_04_29_equipment_breakdown, bp_04_32_outdoor_signs, bp_04_33_fine_arts, bp_04_35_scheduled_equipment, bp_04_47_designated_person_organization, bp_04_50_owners_lessees_contractors, bp_04_55_increased_limits_money, bp_04_56_waiver_subrogation, bp_04_57_primary_noncontributory, bp_04_68_cyber, bp_04_70_epli, bp_05_01_hired_non_owned_auto, bp_15_14_limited_fungi_bacteria, other)   ; Type of endorsement

description = :                               ; Description of the endorsement
premium_impact = #$                           ; Premium impact of the endorsement (positive or negative)

; ═══════════════════════════════════════════════════════════════════════════════
; BOP Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@bop_policy}
id = :                                        ; Unique policy identifier
number = !:                                   ; BOP policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = !date                        ; Policy effective date
effective_time = time                         ; Policy effective time
expiration_date = !date                       ; Policy expiration date
expiration_time = time                        ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Form Type
; ───────────────────────────────────────────────────────────────────────────────
property_form = !(                            ; BOP property coverage form type
    bp_00_02_standard,                        ; Named perils
    bp_00_03_special                          ; Open perils
)

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business              ; Reference to the named insured business

; ───────────────────────────────────────────────────────────────────────────────
; Business Classification
; ───────────────────────────────────────────────────────────────────────────────
classification = @bop_classification          ; Business classification for the policy

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @bop_location                   ; Array of insured locations

; ───────────────────────────────────────────────────────────────────────────────
; Liability Coverage
; ───────────────────────────────────────────────────────────────────────────────
liability = @bop_liability                    ; Liability coverage section

; ───────────────────────────────────────────────────────────────────────────────
; Additional Insureds
; ───────────────────────────────────────────────────────────────────────────────
additional_insureds[] = @bop_additional_insured   ; Array of additional insureds

; ───────────────────────────────────────────────────────────────────────────────
; Optional Coverages
; ───────────────────────────────────────────────────────────────────────────────
optional_coverages = @bop_optional_coverage   ; Optional coverages section

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @bop_endorsement             ; Array of policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
property_total = #$:(0..)                     ; Total property coverage premium
liability_total = #$:(0..)                    ; Total liability coverage premium
optional_coverages_total = #$:(0..)           ; Total optional coverages premium
endorsements_total = #$:(0..)                 ; Total endorsements premium
package_discount = #:(-50..0)                 ; Package discount percentage (negative value)
total_estimated = #$:(0..)                    ; Total estimated policy premium
minimum = #$:(0..)                            ; Minimum earned premium
deposit = #$:(0..)                            ; Deposit premium

{@bop_policy}



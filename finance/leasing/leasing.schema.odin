; ===================================================================================
; ODIN Finance Leasing Schema
; ===================================================================================
; Leasing for equipment, vehicle, real estate, and technology with ASC 842/IFRS 16
; accounting classification including finance vs operating lease determination,
; right-of-use assets, and lease liability recognition.
; ===================================================================================

@import "../types.schema.odin" as fin

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.leasing"
version = "1.0.0"
title = "Finance Leasing Schema"
description = "Comprehensive leasing schema for equipment, vehicle, real estate, and technology leases"

{$derivation}
source[0].authority = "Financial Accounting Standards Board"
source[0].citation = "ASC 842 - Leases"
source[0].url = "https://asc.fasb.org/topic&trid=2303479"

source[1].authority = "International Accounting Standards Board"
source[1].citation = "IFRS 16 - Leases"
source[1].url = "https://www.ifrs.org/issued-standards/list-of-standards/ifrs-16-leases/"

source[2].authority = "Uniform Law Commission"
source[2].citation = "UCC Article 2A - Leases"
source[2].url = "https://www.uniformlaws.org/committees/community-home?communitykey=da0e7d65-2b0c-4c95-9ec6-b32d60a11e5c"

source[3].authority = "Internal Revenue Service"
source[3].citation = "Revenue Procedure 2001-28 (Lease vs Purchase)"
source[3].url = "https://www.irs.gov/pub/irs-drop/rp-01-28.pdf"

source[4].authority = "Equipment Leasing and Finance Association"
source[4].citation = "ELFA Model Lease Documentation"
source[4].url = "https://www.elfaonline.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from FASB ASC 842, IASB IFRS 16, UCC Article 2A, IRS guidance, and ELFA standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial leasing schema"
changelog[0].rationale = "Comprehensive leasing coverage for equipment, vehicle, real estate, and technology"

; ===================================================================================
; LESSOR
; ===================================================================================
; Leasing company or asset owner.

{@lessor}
; Required fields first
lessor_id = !:                                  ; Lessor identifier
lessor_type = !(
    bank,                                       ; Bank leasing division
    captive,                                    ; Manufacturer captive (e.g., Cat Financial)
    independent,                                ; Independent leasing company
    manufacturer,                               ; Direct manufacturer leasing
    rental                                      ; Short-term rental company
)
name = !:                                       ; Lessor legal name

; Identification
lei = :/^[A-Z0-9]{20}$/                         ; Legal Entity Identifier
tax_id = *:                                     ; EIN (confidential)
state_of_incorporation = :(2)                   ; State of formation

; Contact
address = @address                              ; Business address
email = *@email                                 ; Primary email
phone = *@phone                                 ; Primary phone

; Licensing
{.licensing}
state_licenses[] = :(2)                         ; States licensed
equipment_types[] = :                           ; Equipment types financed
credit_limit = #$:(0..)                         ; Maximum transaction size

{@lessor}

; ===================================================================================
; LESSEE
; ===================================================================================
; Lease customer/tenant.

{@lessee}
; Required fields first
lessee_id = !:                                  ; Lessee identifier
lessee_type = !(
    corporation,                                ; C-Corp or S-Corp
    government,                                 ; Government entity
    individual,                                 ; Natural person
    llc,                                        ; Limited liability company
    non_profit,                                 ; Non-profit organization
    partnership,                                ; Partnership
    sole_proprietor                             ; Sole proprietor
)
name = !:                                       ; Lessee legal name

; Identification
tax_id = *:                                     ; EIN or SSN (confidential)
duns = :/^\d{9}$/                               ; D-U-N-S number
naics_code = :(6)                               ; NAICS industry code

; Contact
address = @address                              ; Business address
billing_address = @address                      ; Billing address
email = *@email                                 ; Primary email
phone = *@phone                                 ; Primary phone

; ---------------------------------------------------------------------------
; Credit Profile
; ---------------------------------------------------------------------------
{.credit}
credit_score = ##:(300..850)                    ; Credit score
credit_score_model = (fico, fico_sbss, vantage)
credit_score_date = date                        ; Score date
internal_rating = :(1..2)                       ; Internal risk rating
approval_limit = #$:(0..)                       ; Approved credit limit

{@lessee}

; ---------------------------------------------------------------------------
; Guarantors
; ---------------------------------------------------------------------------
guarantors[] = @lease_guarantor                 ; Personal/corporate guarantors

{@lease_guarantor}
guarantor_id = !:                               ; Guarantor identifier
guarantor_type = !(corporate, individual)       ; Guarantor type
name = !:                                       ; Guarantor name
relationship = (affiliate, officer, owner, parent, spouse)
ownership_pct = #:(0..100)                      ; Ownership percentage
guarantee_type = (full, limited, partial)       ; Guarantee coverage
net_worth = *#$                                 ; Net worth (confidential)

; ===================================================================================
; LEASED ASSET
; ===================================================================================
; Asset being leased (equipment, vehicle, property, technology).

{@leased_asset}
; Required fields first
asset_id = !:                                   ; Asset identifier
asset_category = !(
    aircraft,                                   ; Aircraft
    construction,                               ; Construction equipment
    data_center,                                ; Data center equipment
    furniture_fixtures,                         ; FF&E
    industrial,                                 ; Industrial equipment
    it_hardware,                                ; IT hardware
    manufacturing,                              ; Manufacturing equipment
    material_handling,                          ; Forklifts, conveyors
    medical,                                    ; Medical equipment
    office_equipment,                           ; Office equipment
    rail,                                       ; Rail cars
    real_estate,                                ; Real property
    software,                                   ; Software licenses
    telecom,                                    ; Telecom equipment
    truck_trailer,                              ; Trucks and trailers
    vehicle                                     ; Vehicles
)
description = !:                                ; Asset description

; Identification
manufacturer = :                                ; Manufacturer name
model = :                                       ; Model number
serial_number = :                               ; Serial number
vin = *:/^[A-HJ-NPR-Z0-9]{17}$/                  ; VIN (vehicles only)
registration = :                                ; Registration number

; Location
location_address = @address                     ; Asset location
installation_site = :                           ; Installation site description

; Condition
condition = (excellent, fair, good, new, poor)  ; Asset condition
age_months = ##:(0..)                           ; Age in months
estimated_useful_life_months = ##:(1..)         ; Useful life (months)
remaining_useful_life_months = ##:(0..)         ; Remaining life

; ---------------------------------------------------------------------------
; Valuation
; ---------------------------------------------------------------------------
{.valuation}
original_cost = #$:(0..)                        ; Original acquisition cost
fair_market_value = #$:(0..)                    ; Current FMV
fmv_date = date                                 ; FMV date
residual_value = #$:(0..)                       ; Estimated residual
guaranteed_residual = #$:(0..)                  ; Guaranteed residual (if any)
salvage_value = #$:(0..)                        ; End of life salvage
book_value = #$:(0..)                           ; Current book value

{@leased_asset}

; ---------------------------------------------------------------------------
; Equipment-Specific
; ---------------------------------------------------------------------------
{.equipment}
capacity = :                                    ; Capacity specification
power_requirements = :                          ; Power specs
dimensions = :                                  ; Physical dimensions
weight = :                                      ; Weight
maintenance_schedule = :                        ; Required maintenance

{@leased_asset}

; ---------------------------------------------------------------------------
; Vehicle-Specific
; ---------------------------------------------------------------------------
{.vehicle}
year = ##:(1900..2100)                          ; Model year
make = :                                        ; Vehicle make
body_type = :                                   ; Body type
fuel_type = (diesel, electric, gas, hybrid)     ; Fuel type
odometer = ##:(0..)                             ; Current odometer
gvw = ##:(0..)                                  ; Gross vehicle weight
dot_number = :                                  ; DOT number (commercial)
license_plate = :                               ; License plate
license_state = :(2)                            ; License state

{@leased_asset}

; ---------------------------------------------------------------------------
; Real Estate-Specific
; ---------------------------------------------------------------------------
{.real_estate}
property_type = (
    industrial,
    office,
    retail,
    warehouse
):if asset_category = real_estate
square_footage = ##:if asset_category = real_estate
land_area_acres = #:if asset_category = real_estate
year_built = ##:if asset_category = real_estate
floors = ##:if asset_category = real_estate
parking_spaces = ##:if asset_category = real_estate
zoning = ::if asset_category = real_estate

{@leased_asset}

; ---------------------------------------------------------------------------
; Technology-Specific
; ---------------------------------------------------------------------------
{.technology}
software_version = ::if asset_category = software
license_type = (
    enterprise,
    per_seat,
    perpetual,
    subscription
):if asset_category = software
concurrent_users = ##:if asset_category = software
upgrade_rights = ?:if asset_category = software

{@leased_asset}

; ===================================================================================
; LEASE
; ===================================================================================
; Core lease agreement structure.

{@lease}
; Required fields first
lease_id = !:                                   ; Lease identifier
lease_type = !(
    capital,                                    ; Capital/finance lease (pre-ASC 842)
    direct_finance,                             ; Direct financing lease (lessor)
    finance,                                    ; Finance lease (ASC 842)
    leveraged,                                  ; Leveraged lease
    operating,                                  ; Operating lease
    saas,                                       ; Software as a service
    sale_leaseback,                             ; Sale-leaseback
    sales_type                                  ; Sales-type lease (lessor)
)
lease_structure = !(
    clo,                                        ; Closed-end lease
    fmv,                                        ; FMV lease
    hire_purchase,                              ; Hire purchase (UK)
    municipal,                                  ; Municipal/tax-exempt
    operating,                                  ; Operating/rental
    oper,                                       ; Open-end lease
    trac                                        ; TRAC lease (vehicles)
)

; Parties
lessor = !@lessor                               ; Lessor
lessee = !@lessee                               ; Lessee

; Assets
assets[] = !@leased_asset                       ; Leased assets

; Status
status = (
    active,                                     ; Active lease
    approved,                                   ; Approved, pending docs
    buyout,                                     ; Buyout in progress
    cancelled,                                  ; Cancelled
    default,                                    ; In default
    expired,                                    ; Expired
    extension,                                  ; Extended term
    funded,                                     ; Funded
    matured,                                    ; Matured, end of term
    pending,                                    ; Pending approval
    terminated,                                 ; Early termination
    written_off                                 ; Written off
)

; ---------------------------------------------------------------------------
; Term
; ---------------------------------------------------------------------------
{.term}
commencement_date = !date                       ; Lease commencement
termination_date = !date                        ; Scheduled termination
term_months = ##:(1..)                          ; Original term (months)
remaining_months = ##:(0..)                     ; Remaining months
renewal_options = ##:(0..)                      ; Renewal option terms (months)
renewal_terms[] = @renewal_option               ; Detailed renewal options
extension_months = ##:(0..)                     ; Extension term

{@lease}

{@renewal_option}
option_number = !##:(1..)                       ; Option sequence
term_months = !##:(1..)                         ; Renewal term
rate_adjustment = #                             ; Rate adjustment %
notice_days = ##                                ; Notice required
reasonably_certain = ?                          ; Reasonably certain to exercise

; ---------------------------------------------------------------------------
; Financial Terms
; ---------------------------------------------------------------------------
{@lease}

{.financials}
equipment_cost = #$:(0..)                       ; Lessor cost
capitalized_cost = #$:(0..)                     ; Capitalized cost
net_capitalized_cost = #$:(0..)                 ; After cap cost reduction
residual_value = #$:(0..)                       ; End of term residual
guaranteed_residual = #$:(0..)                  ; Lessee guaranteed residual
implicit_rate = #.4                             ; Implicit interest rate
incremental_borrowing_rate = #.4                ; Lessee IBR
money_factor = #.6                              ; Money factor (lease rate/2400)
gross_investment = #$:(0..)                     ; Gross investment in lease
net_investment = #$:(0..)                       ; Net investment in lease

{@lease}

; ---------------------------------------------------------------------------
; Payment Terms
; ---------------------------------------------------------------------------
{.payment}
payment_frequency = !(
    annual,
    monthly,
    quarterly,
    semi_annual
)
payment_timing = !(advance, arrears)            ; Advance or arrears
base_rent = #$:(0..)                            ; Base rent payment
first_payment_date = date                       ; First payment date
payment_day = ##:(1..31)                        ; Payment due day
payment_count = ##:(1..)                        ; Total payments
final_payment_date = date                       ; Final payment date

; Payment structure
payment_structure = (
    level,                                      ; Level payments
    seasonal,                                   ; Seasonal (skipped periods)
    skip,                                       ; Skip payments
    step_down,                                  ; Step-down payments
    step_up                                     ; Step-up payments
)
deferred_payments = ##:(0..)                    ; Deferred payment months

{@lease}

; ---------------------------------------------------------------------------
; Fees
; ---------------------------------------------------------------------------
{.fees}
documentation_fee = #$:(0..)                    ; Doc fee
origination_fee = #$:(0..)                      ; Origination fee
security_deposit = #$:(0..)                     ; Security deposit
advance_payments = ##:(0..)                     ; Advance payment count
advance_payment_amount = #$:(0..)               ; Advance payment total
acquisition_fee = #$:(0..)                      ; Acquisition fee
disposition_fee = #$:(0..)                      ; End of term disposition
excess_mileage_rate = #$:(0..):if assets[].asset_category = vehicle
excess_wear_reserve = #$:(0..)                  ; Excess wear reserve
late_fee = #$:(0..)                             ; Late payment fee
late_fee_grace_days = ##:(0..)                  ; Grace period

{@lease}

; ---------------------------------------------------------------------------
; End of Term Options
; ---------------------------------------------------------------------------
{.end_of_term}
purchase_option = ?                             ; Has purchase option
purchase_option_price = #$:(0..)                ; Purchase option amount
purchase_option_type = (
    bargain,                                    ; Bargain purchase option
    dollar_buyout,                              ; $1 buyout
    fair_market_value,                          ; FMV purchase
    fixed,                                      ; Fixed price
    percentage                                  ; % of original cost
)
reasonably_certain_to_purchase = ?              ; ASC 842 assessment
renewal_option = ?                              ; Has renewal option
return_option = ?                               ; Return at end of term
return_conditions[] = :                         ; Return conditions

{@lease}

; ---------------------------------------------------------------------------
; Insurance and Maintenance
; ---------------------------------------------------------------------------
{.insurance}
insurance_required = ?                          ; Insurance required
minimum_coverage = #$:(0..)                     ; Minimum coverage
lessor_named_insured = ?                        ; Lessor as additional insured
liability_minimum = #$:(0..)                    ; Liability minimum
physical_damage_required = ?                    ; Physical damage coverage

{@lease}

{.maintenance}
maintenance_type = (
    full_service,                               ; Lessor maintains
    lessee_responsible,                         ; Lessee maintains
    shared                                      ; Shared responsibility
)
maintenance_reserve = #$:(0..)                  ; Monthly maintenance reserve
return_conditions = :                           ; Return condition specs

{@lease}

; ===================================================================================
; ASC 842 / IFRS 16 LEASE ACCOUNTING
; ===================================================================================
; Lease classification and accounting per ASC 842/IFRS 16.

{@lease_accounting}
; Required fields first
lease_id = !:                                   ; Lease reference
accounting_standard = !(asc_842, ifrs_16)       ; Applicable standard

; Classification (Lessee)
{.lessee_classification}
classification = !(finance, operating)          ; ASC 842 classification
classification_date = date                      ; Classification date

; ASC 842 Classification Criteria (finance if any is true)
ownership_transfer = ?                          ; Title transfers at end
bargain_purchase_option = ?                     ; Has BPO
lease_term_major_part = ?                       ; >= 75% of useful life
pv_substantially_all = ?                        ; PV >= 90% of FMV
specialized_asset = ?                           ; No alternative use to lessor

{@lease_accounting}

; Classification (Lessor)
{.lessor_classification}
classification = (direct_financing, operating, sales_type)
classification_date = date                      ; Classification date
collectibility_probable = ?                     ; Collection probable
selling_profit_exists = ?                       ; Has selling profit

{@lease_accounting}

; ---------------------------------------------------------------------------
; Right-of-Use Asset (Lessee)
; ---------------------------------------------------------------------------
{.rou_asset}
initial_value = #$:(0..)                        ; Initial ROU asset
lease_liability_at_commencement = #$:(0..)      ; Initial lease liability
prepaid_lease_payments = #$:(0..)               ; Prepaid rent
initial_direct_costs = #$:(0..)                 ; Initial direct costs
lease_incentives = #$:(0..)                     ; Lease incentives received
current_carrying_amount = #$:(0..)              ; Current book value

; Amortization
amortization_method = (declining_balance, straight_line, units_of_production)
accumulated_amortization = #$:(0..)             ; Accumulated amortization
amortization_period_months = ##:(1..)           ; Amortization period

{@lease_accounting}

; ---------------------------------------------------------------------------
; Lease Liability (Lessee)
; ---------------------------------------------------------------------------
{.lease_liability}
initial_liability = #$:(0..)                    ; Initial lease liability
discount_rate = #.4                             ; Discount rate used
discount_rate_type = (
    implicit,                                   ; Rate implicit in lease
    incremental_borrowing                       ; Lessee IBR
)
current_liability = #$:(0..)                    ; Current lease liability
current_portion = #$:(0..)                      ; Due within 12 months
non_current_portion = #$:(0..)                  ; Due after 12 months

{@lease_accounting}

; ---------------------------------------------------------------------------
; Lease Cost (Lessee - Operating)
; ---------------------------------------------------------------------------
{.operating_lease_cost}
total_lease_cost = #$:(0..)                     ; Total lease cost
single_lease_cost = #$:(0..)                    ; Single lease cost (P&L)
variable_lease_cost = #$:(0..)                  ; Variable payments
short_term_lease_cost = #$:(0..)                ; Short-term leases (<12 mo)

{@lease_accounting}

; ---------------------------------------------------------------------------
; Lease Cost (Lessee - Finance)
; ---------------------------------------------------------------------------
{.finance_lease_cost}
amortization_expense = #$:(0..)                 ; ROU amortization
interest_expense = #$:(0..)                     ; Interest on liability
total_finance_lease_cost = #$:(0..)             ; Total cost
variable_lease_cost = #$:(0..)                  ; Variable payments

{@lease_accounting}

; ---------------------------------------------------------------------------
; Lessor Accounting
; ---------------------------------------------------------------------------
{.lessor}
gross_investment = #$:(0..)                     ; Gross investment in lease
unearned_income = #$:(0..)                      ; Unearned income
net_investment = #$:(0..)                       ; Net investment
selling_profit = #$:(0..)                       ; Selling profit (sales-type)
cost_of_sale = #$:(0..)                         ; Cost of sale
residual_asset = #$:(0..)                       ; Unguaranteed residual

{@lease_accounting}

; ===================================================================================
; EQUIPMENT LEASE
; ===================================================================================
; Equipment-specific lease fields.

{@equipment_lease}
= @lease                                        ; Inherit base lease

; Equipment financing type
equipment_type = !(
    construction,
    data_center,
    industrial,
    manufacturing,
    material_handling,
    medical,
    office,
    printing,
    telecom,
    other
)

; Master lease
master_lease = ?                                ; Master lease agreement
master_lease_number = ::if master_lease = true  ; Master lease reference
schedule_number = ::if master_lease = true      ; Schedule under master

; Progress payments (for large equipment)
{.progress}
progress_payment_enabled = ?                    ; Progress funding
progress_milestones[] = @progress_milestone     ; Payment milestones

{@equipment_lease}

{@progress_milestone}
milestone_id = !:                               ; Milestone identifier
description = !:                                ; Milestone description
target_date = !date                             ; Target date
payment_amount = !#$:(0..)                      ; Payment amount
payment_percentage = #:(0..100)                 ; % of total
status = (approved, completed, pending)         ; Status
completion_date = date                          ; Actual completion

; Installation
{@equipment_lease}

{.installation}
installation_required = ?                       ; Installation needed
installation_included = ?                       ; In lease cost
installation_vendor = :                         ; Installation vendor
installation_date = date                        ; Scheduled install
commissioning_date = date                       ; Commissioning date
acceptance_date = date                          ; Lessee acceptance

{@equipment_lease}

; ===================================================================================
; VEHICLE LEASE
; ===================================================================================
; Vehicle/fleet-specific lease fields.

{@vehicle_lease}
= @lease                                        ; Inherit base lease

; Vehicle lease type
vehicle_lease_type = !(
    commercial,                                 ; Commercial vehicles
    consumer,                                   ; Consumer auto lease
    fleet,                                      ; Fleet lease
    specialty                                   ; Specialty vehicles
)

; TRAC Lease (Terminal Rental Adjustment Clause)
trac_lease = ?                                  ; TRAC lease
trac_adjustment = #$:if trac_lease = true       ; TRAC adjustment amount

; Mileage terms
{.mileage}
annual_mileage_limit = ##:(0..)                 ; Annual limit
total_mileage_limit = ##:(0..)                  ; Total lease limit
excess_mileage_rate = #$:(0..)                  ; Per mile excess rate
current_odometer = ##:(0..)                     ; Current reading
odometer_date = date                            ; Reading date

{@vehicle_lease}

; Wear and use
{.wear_and_use}
normal_wear_defined = ?                         ; Wear standards defined
wear_standards_document = :                     ; Standards document
excess_wear_charge = #$:(0..)                   ; Estimated excess wear

{@vehicle_lease}

; Fleet services (if fleet lease)
{.fleet_services}
maintenance_included = ?                        ; Maintenance program
fuel_cards = ?                                  ; Fuel card program
telematics = ?                                  ; Telematics included
driver_services = ?                             ; Driver safety services
roadside_assistance = ?                         ; Roadside included
substitute_vehicle = ?                          ; Sub vehicle program

{@vehicle_lease}

; ===================================================================================
; REAL ESTATE LEASE
; ===================================================================================
; Commercial real estate lease fields.

{@real_estate_lease}
= @lease                                        ; Inherit base lease

; Property type
property_category = !(
    flex,
    industrial,
    mixed_use,
    office,
    retail,
    warehouse
)

; Space details
{.space}
rentable_square_feet = ##:(0..)                 ; Rentable SF
usable_square_feet = ##:(0..)                   ; Usable SF
load_factor = #:(1..2)                          ; Load factor
floor_number = ##                               ; Floor number
suite_number = :                                ; Suite number

{@real_estate_lease}

; Rent structure
{.rent}
base_rent_psf = #$:(0..)                        ; Base rent per SF
annual_base_rent = #$:(0..)                     ; Annual base rent
rent_type = (
    full_service,                               ; Gross lease
    modified_gross,                             ; Modified gross
    net,                                        ; Single net (N)
    nnn,                                        ; Triple net (NNN)
    percentage                                  ; Retail percentage
)

; Escalations
escalation_type = (cpi, fixed, market)          ; Escalation method
escalation_rate = #:(0..10)                     ; Annual escalation %
escalation_frequency = (annual, biennial)       ; Escalation frequency
base_year = ##:(2000..2100)                     ; Base year for expenses

{@real_estate_lease}

; Operating expenses (NNN)
{.operating_expenses}
cam_estimate = #$:(0..)                         ; CAM estimate
property_tax_estimate = #$:(0..)                ; Property tax
insurance_estimate = #$:(0..)                   ; Insurance
utilities_included = ?                          ; Utilities in rent
janitorial_included = ?                         ; Janitorial in rent
management_fee_pct = #:(0..10)                  ; Management fee %

{@real_estate_lease}

; Tenant improvements
{.tenant_improvements}
ti_allowance = #$:(0..)                         ; TI allowance ($)
ti_allowance_psf = #$:(0..)                     ; TI per SF
landlord_work = :                               ; Landlord work scope
tenant_work = :                                 ; Tenant work scope
construction_period_days = ##                   ; Build-out period
rent_commencement_trigger = (
    certificate_of_occupancy,
    completion,
    days_after_delivery,
    earlier_of
)

{@real_estate_lease}

; Retail-specific
{.retail}
percentage_rent = ?:if property_category = retail
percentage_rate = #:(0..20):if percentage_rent = true
breakpoint = #$:(0..):if percentage_rent = true  ; Sales breakpoint
sales_reporting_frequency = (monthly, quarterly):if percentage_rent = true
exclusive_use = ::if property_category = retail  ; Exclusive use clause
co_tenancy = ?:if property_category = retail     ; Co-tenancy clause

{@real_estate_lease}

; ===================================================================================
; TECHNOLOGY LEASE
; ===================================================================================
; IT equipment and software lease fields.

{@technology_lease}
= @lease                                        ; Inherit base lease

; Technology category
tech_category = !(
    cloud_infrastructure,
    data_center,
    desktop_laptop,
    network_equipment,
    server,
    software,
    storage,
    telecom
)

; Technology refresh
{.refresh}
tech_refresh_enabled = ?                        ; Refresh program
refresh_interval_months = ##                    ; Refresh cycle
refresh_method = (
    fair_market_value,                          ; FMV at refresh
    fixed_schedule,                             ; Fixed schedule
    rolling                                     ; Rolling refresh
)
evergreen = ?                                   ; Evergreen/continuous

{@technology_lease}

; Software licensing
{.software}
license_type = (
    enterprise,
    named_user,
    per_cpu,
    per_device,
    saas,
    site
):if tech_category = software
license_quantity = ##:if tech_category = software
license_term_months = ##:if tech_category = software
upgrade_rights = ?:if tech_category = software
support_included = ?:if tech_category = software
support_level = (basic, premium, standard):if tech_category = software

{@technology_lease}

; Managed services
{.managed_services}
managed_services_included = ?                   ; MSP included
help_desk = ?                                   ; Help desk support
monitoring = ?                                  ; 24x7 monitoring
patch_management = ?                            ; Patch management
backup_services = ?                             ; Backup included
disaster_recovery = ?                           ; DR services

{@technology_lease}

; Data handling
{.data_handling}
data_sanitization = ?                           ; Data wipe at return
certification_required = ?                      ; NIST/DoD certification
chain_of_custody = ?                            ; Chain of custody docs

{@technology_lease}

; ===================================================================================
; SALE-LEASEBACK
; ===================================================================================
; Sale-leaseback transaction.

{@sale_leaseback}
; Required fields first
transaction_id = !:                             ; Transaction identifier
seller_lessee = !@lessee                        ; Seller-lessee
buyer_lessor = !@lessor                         ; Buyer-lessor

; Sale component
{.sale}
sale_date = !date                               ; Sale date
sale_price = !#$:(0..)                          ; Sale price
fair_value = #$:(0..)                           ; Fair value at sale
book_value = #$:(0..)                           ; Seller book value
gain_on_sale = #$                               ; Gain (can be negative)
gain_deferred = #$:(0..)                        ; Deferred gain (if any)
qualifies_as_sale = ?                           ; ASC 842 sale criteria met

{@sale_leaseback}

; Leaseback component
{.leaseback}
lease = @lease                                  ; Leaseback lease
lease_classification = (finance, operating)     ; Classification
repurchase_option = ?                           ; Repurchase option
repurchase_price = #$:(0..)                     ; Repurchase price

{@sale_leaseback}

; Accounting treatment
{.accounting}
failed_sale = ?                                 ; Sale not recognized
financing_treatment = ?                         ; Treat as financing
off_balance_sheet = ?                           ; Off-balance sheet treatment
gain_recognition = (
    immediate,                                  ; Full gain at sale
    over_lease_term,                            ; Amortize over term
    partially_deferred                          ; Partial deferral
)

{@sale_leaseback}

; ===================================================================================
; LEASE PAYMENT
; ===================================================================================
; Lease payment transaction.

{@lease_payment}
; Required fields first
payment_id = !:                                 ; Payment identifier
lease_id = !:                                   ; Lease reference
payment_date = !date                            ; Payment date
total_amount = !#$:(0..)                        ; Total payment

; Payment allocation
base_rent = #$:(0..)                            ; Base rent portion
interest = #$:(0..)                             ; Interest portion
principal = #$:(0..)                            ; Principal portion
property_tax = #$:(0..)                         ; Property tax
insurance = #$:(0..)                            ; Insurance
maintenance = #$:(0..)                          ; Maintenance
cam = #$:(0..)                                  ; CAM charges
sales_tax = #$:(0..)                            ; Sales tax
late_charges = #$:(0..)                         ; Late charges
other = #$:(0..)                                ; Other charges

; Payment details
payment_type = (
    advance,                                    ; Advance payment
    buyout,                                     ; Buyout payment
    final,                                      ; Final payment
    interim,                                    ; Interim rent
    other,                                      ; Other
    regular,                                    ; Regular payment
    security_deposit                            ; Security deposit
)
payment_method = (ach, check, wire)             ; Payment method
reference = :                                   ; Payment reference

; Status
status = (applied, nsf, pending, reversed)      ; Payment status
effective_date = date                           ; Value date

; ===================================================================================
; LEASE TERMINATION
; ===================================================================================
; Early lease termination.

{@lease_termination}
; Required fields first
termination_id = !:                             ; Termination identifier
lease_id = !:                                   ; Lease reference
termination_date = !date                        ; Effective termination date

; Reason
termination_reason = !(
    borrower_request,                           ; Lessee request
    casualty_loss,                              ; Total loss
    default,                                    ; Lessee default
    early_buyout,                               ; Early buyout
    equipment_obsolescence,                     ; Technology obsolete
    mutual_agreement,                           ; Mutual termination
    sale_of_business                            ; Business sale
)

; Financial settlement
{.settlement}
termination_value = #$:(0..)                    ; Stipulated loss value
remaining_payments = #$:(0..)                   ; Remaining payments
present_value = #$:(0..)                        ; PV of remaining
residual = #$:(0..)                             ; Residual value
total_due = #$:(0..)                            ; Total termination amount
amount_paid = #$:(0..)                          ; Amount paid
waived_amount = #$:(0..)                        ; Amount waived

{@lease_termination}

; Asset disposition
{.asset}
asset_returned = ?                              ; Asset returned
return_date = date                              ; Return date
condition_at_return = (excellent, fair, good, poor)
disposition = (
    re_leased,                                  ; Re-leased to new lessee
    remarketed,                                 ; Sold
    retained                                    ; Held for other use
)
sale_proceeds = #$:(0..)                        ; If sold

{@lease_termination}


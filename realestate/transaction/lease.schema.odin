; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Lease Transaction Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Commercial and residential lease agreements including ground leases, triple
; net, gross, and modified gross structures. Covers lease terms, rent
; escalations, tenant improvements, operating expenses, renewal options,
; and tenant/landlord obligations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.transaction.lease"
version = "1.0.0"
title = "Real Estate Lease Transaction Schema"
description = "Comprehensive residential and commercial lease agreements"

{$derivation}
source[0].authority = "Uniform Residential Landlord Tenant Act (URLTA)"
source[0].citation = "Model residential lease requirements"
source[0].url = "https://www.uniformlaws.org/committees/community-home?CommunityKey=6b3b9c0e-c88e-4a12-9f7a-8f2d4c0e1f5a"

source[1].authority = "BOMA International"
source[1].citation = "Commercial lease measurement standards"
source[1].url = "https://www.boma.org/"

source[2].authority = "NAIOP Commercial Real Estate Association"
source[2].citation = "Commercial lease best practices"
source[2].url = "https://www.naiop.org/"

source[3].authority = "State Landlord-Tenant Laws"
source[3].citation = "Various state landlord-tenant statutes"
source[3].url = "https://www.nolo.com/legal-encyclopedia/landlord-tenant-law"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Lease schema derived from URLTA, state landlord-tenant laws, and commercial standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial lease transaction schema"
changelog[0].rationale = "Comprehensive lease structure for residential and commercial"

; ═══════════════════════════════════════════════════════════════════════════════
; LEASE TENANT
; ═══════════════════════════════════════════════════════════════════════════════
; Tenant party to a lease agreement

{@lease_tenant}
= @person                                         ; Inherits person fields for individuals

; Tenant type (individual or business)
tenant_type = !(business, individual)

; Business tenant info (if business)
business_name = ::if tenant_type = business       ; Business legal name
business_type = (corporation, llc, partnership, sole_proprietor):if tenant_type = business
ein = *::if tenant_type = business                ; Employer ID Number
dba = ::if tenant_type = business                 ; DBA name

; Guarantor (if required)
{.guarantor}
required = ?                                      ; Guarantor required
guarantor_name = ::if required = true             ; Guarantor name
guarantor_address = @address:if required = true   ; Guarantor address
guarantor_phone = *@phone:if required = true      ; Guarantor phone

{@lease_tenant}

; Credit/background
{.screening}
credit_checked = ?                                ; Credit check performed
credit_score = ##:(300..850):if credit_checked = true
background_checked = ?                            ; Background check performed
employment_verified = ?                           ; Employment verified
income_verified = ?                               ; Income verified
monthly_income = #$:(0..):if income_verified = true

{@lease_tenant}

; ═══════════════════════════════════════════════════════════════════════════════
; LEASE AGREEMENT - RESIDENTIAL
; ═══════════════════════════════════════════════════════════════════════════════

{@residential_lease}
; Required fields first
lease_type = "residential"                        ; Lease type discriminator
property_address = !@address                      ; Property address
commencement_date = !date                         ; Lease start date
expiration_date = !date                           ; Lease end date
monthly_rent = !#$:(0..)                          ; Monthly rent amount

:invariant expiration_date > commencement_date    ; End must be after start

; Lease identification
lease_id = :                                      ; Unique lease identifier
unit_number = :                                   ; Unit/apartment number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
landlord = @re_party                              ; Landlord/owner
landlord_company = @re_company                    ; Property management company
tenants[] = @lease_tenant                         ; Tenant(s)
occupants[] = :                                   ; Other authorized occupants

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
term_type = !(fixed, month_to_month, week_to_week)
term_months = ##:(1..):if term_type = fixed       ; Fixed term length
auto_renew = ?                                    ; Auto-renewal provision
renewal_term_months = ##:(1..):if auto_renew = true
notice_to_vacate_days = ##:(1..)                  ; Required notice to vacate
notice_of_non_renewal_days = ##:(1..)             ; Non-renewal notice required

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Rent
; ───────────────────────────────────────────────────────────────────────────────
{.rent}
base_rent = !#$:(0..)                             ; Base monthly rent
rent_due_day = ##:(1..31)                         ; Day of month rent due
grace_period_days = ##:(0..)                      ; Grace period for late rent
late_fee = #$:(0..)                               ; Late fee amount
late_fee_type = (fixed, percentage)               ; Late fee calculation
late_fee_percent = #:(0..100):if late_fee_type = percentage
nsf_fee = #$:(0..)                                ; Returned check fee
payment_methods[] = (ach, cash, check, credit_card, money_order, online)

{@residential_lease}

; Rent increases
{.rent.increase}
allowed = ?                                       ; Rent increases allowed
increase_cap_percent = #:(0..100):if allowed = true  ; Maximum increase
notice_days = ##:(1..):if allowed = true          ; Notice required

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Security Deposit
; ───────────────────────────────────────────────────────────────────────────────
{.deposit}
security_deposit = #$:(0..)                       ; Security deposit amount
security_deposit_held_by = :                      ; Who holds deposit
last_month_rent = #$:(0..)                        ; Last month's rent collected
pet_deposit = #$:(0..)                            ; Pet deposit
other_deposits = #$:(0..)                         ; Other deposits
interest_bearing = ?                              ; Deposit earns interest
return_deadline_days = ##:(1..)                   ; Days to return deposit

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Utilities
; ───────────────────────────────────────────────────────────────────────────────
{.utilities}
electric_paid_by = (landlord, tenant)             ; Electric responsibility
gas_paid_by = (landlord, tenant)                  ; Gas responsibility
water_paid_by = (landlord, tenant)                ; Water responsibility
sewer_paid_by = (landlord, tenant)                ; Sewer responsibility
trash_paid_by = (landlord, tenant)                ; Trash responsibility
internet_paid_by = (landlord, tenant)             ; Internet responsibility
cable_paid_by = (landlord, tenant)                ; Cable responsibility

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Pets
; ───────────────────────────────────────────────────────────────────────────────
{.pets}
pets_allowed = ?                                  ; Pets permitted
pet_types_allowed[] = (bird, cat, dog, fish, other, reptile, small_animal):if pets_allowed = true
max_pets = ##:(0..):if pets_allowed = true        ; Maximum pets allowed
weight_limit_lbs = ##:(0..):if pets_allowed = true
breed_restrictions[] = ::if pets_allowed = true   ; Restricted breeds
pet_rent = #$:(0..):if pets_allowed = true        ; Monthly pet rent
pet_deposit = #$:(0..):if pets_allowed = true     ; Pet deposit

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Parking
; ───────────────────────────────────────────────────────────────────────────────
{.parking}
included = ?                                      ; Parking included
spaces = ##:(0..):if included = true              ; Number of spaces
assigned_spaces[] = ::if included = true          ; Assigned space numbers
garage = ?:if included = true                     ; Garage parking
additional_parking_fee = #$:(0..)                 ; Additional parking fee
guest_parking = ?                                 ; Guest parking available

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Rules and Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.rules}
smoking_allowed = ?                               ; Smoking permitted
subletting_allowed = ?                            ; Subletting permitted
guests_max_days = ##:(0..)                        ; Max consecutive guest days
quiet_hours_start = time                          ; Quiet hours begin
quiet_hours_end = time                            ; Quiet hours end
alterations_allowed = ?                           ; Alterations permitted
renters_insurance_required = ?                    ; Insurance required
minimum_coverage = #$:(0..):if renters_insurance_required = true

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Maintenance
; ───────────────────────────────────────────────────────────────────────────────
{.maintenance}
landlord_responsible[] = :                        ; Landlord maintenance items
tenant_responsible[] = :                          ; Tenant maintenance items
emergency_contact = @re_party                     ; Emergency maintenance contact
emergency_phone = *@phone                         ; Emergency phone

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Move-In/Move-Out
; ───────────────────────────────────────────────────────────────────────────────
{.move_in}
inspection_date = date                            ; Move-in inspection date
inspection_complete = ?                           ; Inspection completed
condition_report = ?                              ; Condition report signed
keys_provided = ##:(0..)                          ; Number of keys provided

{@residential_lease}
{.move_out}
inspection_date = date                            ; Move-out inspection date
forwarding_address = @address                     ; Forwarding address
deposit_disposition_date = date                   ; Deposit disposition sent

{@residential_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Lease Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, eviction, expired, month_to_month, pending, renewed, terminated)
status_date = date                                ; Status change date
early_termination = ?                             ; Early termination
termination_fee = #$:(0..):if early_termination = true
termination_reason = ::if status = terminated     ; Termination reason

; ═══════════════════════════════════════════════════════════════════════════════
; LEASE AGREEMENT - COMMERCIAL
; ═══════════════════════════════════════════════════════════════════════════════

{@commercial_lease}
; Required fields first
lease_type = "commercial"                         ; Lease type discriminator
property_address = !@address                      ; Property address
commencement_date = !date                         ; Lease start date
expiration_date = !date                           ; Lease end date
annual_base_rent = !#$:(0..)                      ; Annual base rent

:invariant expiration_date > commencement_date    ; End must be after start

; Lease identification
lease_id = :                                      ; Unique lease identifier
suite_number = :                                  ; Suite/space number

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
landlord = @re_party                              ; Landlord/owner
landlord_company = @re_company                    ; Property owner entity
tenant = @lease_tenant                            ; Tenant
tenant_company = @re_company                      ; Tenant business entity
listing_broker = @re_company                      ; Listing broker
tenant_broker = @re_company                       ; Tenant's broker

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Premises
; ───────────────────────────────────────────────────────────────────────────────
{.premises}
rentable_sqft = ##:(0..)                          ; Rentable square feet
usable_sqft = ##:(0..)                            ; Usable square feet
common_area_factor = #:(0..100)                   ; Load factor percentage
pro_rata_share = #:(0..100)                       ; Tenant's pro-rata share
floor = ##                                        ; Floor number
suite = :                                         ; Suite designation
permitted_use = :                                 ; Permitted use of premises
exclusive_use = ?                                 ; Exclusive use provision
exclusive_use_description = ::if exclusive_use = true

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
{.term}
term_months = ##:(1..)                            ; Initial term months
term_years = ##:(0..)                             ; Initial term years
rent_commencement_date = date                     ; Rent commencement (may differ)
free_rent_months = ##:(0..)                       ; Free rent period
beneficial_occupancy_date = date                  ; Early access date

{@commercial_lease}

; Renewal options
{.term.renewal}
option_count = ##:(0..)                           ; Number of renewal options
option_term_months = ##:(0..)                     ; Each option term
option_notice_months = ##:(1..)                   ; Notice required
option_rent_type = (cpi_adjusted, fair_market, fixed_increase, negotiated)
option_increase_percent = #:(0..100):if option_rent_type = fixed_increase

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Rent Structure
; ───────────────────────────────────────────────────────────────────────────────
lease_structure = !(absolute_net, double_net, full_service, gross, modified_gross, triple_net)

{.rent}
base_rent_annual = !#$:(0..)                      ; Annual base rent
base_rent_monthly = #$:(0..)                      ; Monthly base rent
base_rent_psf = #$:(0..)                          ; Rent per square foot
rent_due_day = ##:(1..31)                         ; Day of month rent due

{@commercial_lease}

; Rent escalations
{.rent.escalation}
type = (cpi, fixed_amount, fixed_percent, market, step)
annual_increase_percent = #:(0..100):if type = fixed_percent
annual_increase_amount = #$:(0..):if type = fixed_amount
cpi_index = ::if type = cpi                       ; CPI index used
cpi_cap = #:(0..100):if type = cpi                ; CPI cap percentage

{@commercial_lease}

; Rent schedule
{.rent.schedule[]}
period_start = date                               ; Period start date
period_end = date                                 ; Period end date
annual_rent = #$:(0..)                            ; Annual rent this period
monthly_rent = #$:(0..)                           ; Monthly rent this period
rent_psf = #$:(0..)                               ; Rent PSF this period

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Operating Expenses (CAM/NNN)
; ───────────────────────────────────────────────────────────────────────────────
{.expenses}
base_year = ##:(2000..2100)                       ; Base year for expenses
base_year_expenses = #$:(0..)                     ; Base year expense amount
current_estimate = #$:(0..)                       ; Current year estimate
monthly_estimate = #$:(0..)                       ; Monthly estimate payment
expense_stop = #$:(0..)                           ; Expense stop amount
gross_up_provision = ?                            ; Gross up to 95% occupancy
audit_rights = ?                                  ; Tenant audit rights
audit_period_months = ##:(0..):if audit_rights = true

{@commercial_lease}

; Expense categories
{.expenses.categories}
cam_included = ?                                  ; CAM charges apply
insurance_included = ?                            ; Insurance pass-through
property_tax_included = ?                         ; Property tax pass-through
utilities_included = ?                            ; Utilities pass-through
management_fee_included = ?                       ; Management fee included
management_fee_percent = #:(0..100):if management_fee_included = true
capital_exclusions = ?                            ; Capital expenses excluded
administrative_fee_percent = #:(0..15)            ; Admin fee on expenses

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Security Deposit
; ───────────────────────────────────────────────────────────────────────────────
{.deposit}
security_deposit = #$:(0..)                       ; Security deposit amount
letter_of_credit = ?                              ; LOC in lieu of cash
loc_amount = #$:(0..):if letter_of_credit = true  ; LOC amount
loc_issuer = ::if letter_of_credit = true         ; LOC issuing bank
reduction_schedule = ?                            ; Deposit reduction over time

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Tenant Improvements
; ───────────────────────────────────────────────────────────────────────────────
{.tenant_improvements}
ti_allowance = #$:(0..)                           ; TI allowance amount
ti_allowance_psf = #$:(0..)                       ; TI allowance per sqft
turnkey = ?                                       ; Landlord builds out
tenant_builds = ?                                 ; Tenant builds out
construction_management_fee = #:(0..100)          ; Landlord CM fee
excess_ti_amortized = ?                           ; Excess TI amortized into rent
amortization_rate = #:(0..100):if excess_ti_amortized = true
completion_deadline = date                        ; Build-out deadline

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Percentage Rent (Retail)
; ───────────────────────────────────────────────────────────────────────────────
{.percentage_rent}
applicable = ?                                    ; Percentage rent applies
breakpoint = #$:(0..):if applicable = true        ; Natural or artificial breakpoint
breakpoint_type = (artificial, natural):if applicable = true
percentage_rate = #:(0..100):if applicable = true ; Percentage above breakpoint
gross_sales_definition = ::if applicable = true   ; What's included in gross sales
exclusions[] = ::if applicable = true             ; Excluded sales
reporting_frequency = (annual, monthly, quarterly):if applicable = true

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Signage
; ───────────────────────────────────────────────────────────────────────────────
{.signage}
building_signage = ?                              ; Building signage rights
monument_signage = ?                              ; Monument sign rights
suite_signage = ?                                 ; Suite door signage
pylon_signage = ?                                 ; Pylon sign rights
signage_specifications = :                        ; Signage requirements

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Parking
; ───────────────────────────────────────────────────────────────────────────────
{.parking}
spaces_allocated = ##:(0..)                       ; Parking spaces
ratio_per_1000 = #:(0..)                          ; Spaces per 1000 sqft
reserved_spaces = ##:(0..)                        ; Reserved/assigned spaces
unreserved_spaces = ##:(0..)                      ; Unreserved spaces
monthly_rate = #$:(0..)                           ; Parking rate per space
parking_included = ?                              ; Parking in base rent

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Assignment and Subletting
; ───────────────────────────────────────────────────────────────────────────────
{.assignment}
assignment_allowed = ?                            ; Assignment permitted
landlord_consent_required = ?:if assignment_allowed = true
subletting_allowed = ?                            ; Subletting permitted
recapture_right = ?                               ; Landlord recapture right
profit_sharing = ?                                ; Landlord share of profits
profit_share_percent = #:(0..100):if profit_sharing = true

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Options
; ───────────────────────────────────────────────────────────────────────────────
{.options}
expansion_option = ?                              ; Right to expand
expansion_sqft = ##:(0..):if expansion_option = true
rofo = ?                                          ; Right of first offer
rofr = ?                                          ; Right of first refusal
termination_option = ?                            ; Early termination right
termination_date = date:if termination_option = true
termination_fee = #$:(0..):if termination_option = true
purchase_option = ?                               ; Option to purchase
purchase_price = #$:(0..):if purchase_option = true

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.insurance}
liability_required = #$:(0..)                     ; Minimum CGL limit
property_required = ?                             ; Property insurance required
workers_comp_required = ?                         ; Workers comp required
umbrella_required = #$:(0..)                      ; Umbrella limit
landlord_additional_insured = ?                   ; Landlord as additional insured
waiver_of_subrogation = ?                         ; Waiver of subrogation

{@commercial_lease}

; ───────────────────────────────────────────────────────────────────────────────
; Lease Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, expired, in_negotiation, month_to_month, pending_commencement, renewed, terminated)
status_date = date                                ; Status change date
termination_reason = ::if status = terminated     ; Termination reason


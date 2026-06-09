; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Insurance Certificate Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Evidence of insurance coverage for commercial certificates of insurance (COI),
; personal auto ID cards, liability certificates, property certificates, and
; other proof of coverage documents.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.certificate"
version = "1.0.0"
title = "Insurance Certificate Schema"
description = "Evidence of insurance coverage for commercial and personal lines"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "Evidence of Insurance Requirements"
source[0].url = "https://www.tdi.texas.gov/"

source[1].authority = "California Department of Insurance"
source[1].citation = "Certificate of Insurance Guidelines"
source[1].url = "https://www.insurance.ca.gov/"

source[2].authority = "New York Department of Financial Services"
source[2].citation = "Insurance Certificate Regulatory Requirements"
source[2].url = "https://www.dfs.ny.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Certificate schema for both commercial COIs and personal insurance ID cards"

changelog[0].date = 2025-12-13
changelog[0].change = "Initial certificate schema"
changelog[0].rationale = "Comprehensive certificate structure for all coverage types"

changelog[1].date = 2025-12-21
changelog[1].change = "Generalized for personal and commercial use"
changelog[1].rationale = "Support personal auto ID cards and other personal lines certificates"

; ═══════════════════════════════════════════════════════════════════════════════
; Certificate Coverage Line
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate_coverage_line}
; Required fields first
policy_number = :                            ; Policy number for this coverage
effective = date                             ; Coverage effective date
expiration = date                            ; Coverage expiration date

; Optional fields
line_id = :                                   ; Unique line identifier
sequence = ##:(1..)                           ; Display sequence order

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Type
; ───────────────────────────────────────────────────────────────────────────────
; Personal Auto Coverages
;   bodily_injury, collision, comprehensive, medical_payments,
;   personal_injury_protection, property_damage, rental_reimbursement,
;   roadside_assistance, uninsured_motorist, underinsured_motorist
;
; Commercial Coverages
;   automobile_liability, builders_risk, general_liability, property,
;   crime, employers_liability, excess_liability, inland_marine,
;   pollution_liability, professional_liability, umbrella_liability,
;   workers_compensation
; ───────────────────────────────────────────────────────────────────────────────
coverage_type = (
    automobile_liability,
    bodily_injury,
    builders_risk,
    collision,
    comprehensive,
    crime,
    employers_liability,
    excess_liability,
    general_liability,
    inland_marine,
    medical_payments,
    other,
    personal_injury_protection,
    pollution_liability,
    professional_liability,
    property,
    property_damage,
    rental_reimbursement,
    roadside_assistance,
    umbrella_liability,
    underinsured_motorist,
    uninsured_motorist,
    workers_compensation
)
coverage_description = ::if coverage_type = other ; Description when coverage_type is other

; ───────────────────────────────────────────────────────────────────────────────
; Carrier Reference
; ───────────────────────────────────────────────────────────────────────────────
carrier_index = ##:(0..)                        ; Index into parent certificate.carriers[]

; Policy Type (for liability)
policy_form = (claims_made, occurrence):if coverage_type = general_liability ; Claims-made or occurrence basis
retroactive_date = date:if policy_form = claims_made ; Retroactive date for claims-made

; ───────────────────────────────────────────────────────────────────────────────
; Liability Limits (General Liability)
; ───────────────────────────────────────────────────────────────────────────────
{.gl}
each_occurrence = ##:if coverage_type = general_liability         ; Per occurrence limit
damage_to_rented_premises = ##:if coverage_type = general_liability ; Fire damage limit
medical_expense = ##:if coverage_type = general_liability         ; Medical expense limit
personal_advertising_injury = ##:if coverage_type = general_liability ; Personal/advertising injury
general_aggregate = ##:if coverage_type = general_liability       ; General aggregate limit
products_completed_ops_aggregate = ##:if coverage_type = general_liability ; Products/completed ops

; Liability Modifiers
aggregate_per = (location, policy, project):if coverage_type = general_liability ; Aggregate applies per
additional_insured = ?:if coverage_type = general_liability       ; Additional insured endorsement
waiver_of_subrogation = ?:if coverage_type = general_liability    ; Waiver of subrogation
primary_noncontributory = ?:if coverage_type = general_liability  ; Primary and non-contributory

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Auto Limits (Commercial)
; ───────────────────────────────────────────────────────────────────────────────
{.auto}
combined_single_limit = ##:if coverage_type = automobile_liability ; CSL limit
bodily_injury_per_person = ##:if coverage_type = automobile_liability ; BI per person
bodily_injury_per_accident = ##:if coverage_type = automobile_liability ; BI per accident
property_damage = ##:if coverage_type = automobile_liability      ; PD limit

; Auto Covered Vehicles
any_auto = ?:if coverage_type = automobile_liability              ; Any auto symbol
all_owned_autos = ?:if coverage_type = automobile_liability       ; All owned autos
scheduled_autos = ?:if coverage_type = automobile_liability       ; Scheduled autos only
hired_autos = ?:if coverage_type = automobile_liability           ; Hired autos coverage
non_owned_autos = ?:if coverage_type = automobile_liability       ; Non-owned autos

; Auto Modifiers
additional_insured = ?:if coverage_type = automobile_liability    ; Additional insured
waiver_of_subrogation = ?:if coverage_type = automobile_liability ; Waiver of subrogation

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Personal Auto Limits
; ───────────────────────────────────────────────────────────────────────────────
{.personal_auto}
; Bodily Injury
bi_per_person = ##:if coverage_type = bodily_injury              ; BI limit per person
bi_per_accident = ##:if coverage_type = bodily_injury            ; BI limit per accident

; Property Damage
pd_limit = ##:if coverage_type = property_damage                 ; PD liability limit

; Collision/Comprehensive
collision_deductible = ##:if coverage_type = collision           ; Collision deductible
comp_deductible = ##:if coverage_type = comprehensive            ; Comprehensive deductible

; Medical/PIP
med_pay_limit = ##:if coverage_type = medical_payments           ; Medical payments limit
pip_limit = ##:if coverage_type = personal_injury_protection     ; PIP coverage limit

; UM/UIM
um_per_person = ##:if coverage_type = uninsured_motorist         ; UM per person
um_per_accident = ##:if coverage_type = uninsured_motorist       ; UM per accident
uim_per_person = ##:if coverage_type = underinsured_motorist     ; UIM per person
uim_per_accident = ##:if coverage_type = underinsured_motorist   ; UIM per accident

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Umbrella/Excess Limits
; ───────────────────────────────────────────────────────────────────────────────
{.umbrella}
each_occurrence = ##:if coverage_type = umbrella_liability       ; Per occurrence limit
aggregate = ##:if coverage_type = umbrella_liability             ; Aggregate limit
retention = ##:if coverage_type = umbrella_liability             ; Self-insured retention
umbrella_or_excess = (excess, umbrella):if coverage_type = umbrella_liability ; Coverage form

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Workers Compensation / Employers Liability
; ───────────────────────────────────────────────────────────────────────────────
{.wc}
statutory = ?:if coverage_type = workers_compensation            ; Statutory limits apply
el_each_accident = ##:if coverage_type = workers_compensation    ; EL each accident
el_disease_employee = ##:if coverage_type = workers_compensation ; EL disease per employee
el_disease_policy_limit = ##:if coverage_type = workers_compensation ; EL disease policy limit
waiver_of_subrogation = ?:if coverage_type = workers_compensation ; Waiver of subrogation

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Professional Liability
; ───────────────────────────────────────────────────────────────────────────────
{.pl}
each_claim = ##:if coverage_type = professional_liability        ; Per claim limit
aggregate = ##:if coverage_type = professional_liability         ; Aggregate limit
retention = ##:if coverage_type = professional_liability         ; Self-insured retention
retroactive_date = date:if coverage_type = professional_liability ; Retroactive date

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Property Limits
; ───────────────────────────────────────────────────────────────────────────────
{.property_coverage}
building = #$:(0..):if coverage_type = property                  ; Building coverage limit
contents = #$:(0..):if coverage_type = property                  ; Contents coverage limit
business_income = #$:(0..):if coverage_type = property           ; Business income limit
deductible = ##:if coverage_type = property                      ; Property deductible
causes_of_loss = (basic, broad, special):if coverage_type = property ; Causes of loss form
valuation = (actual_cash_value, replacement_cost):if coverage_type = property ; Valuation method

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Builders Risk Limits
; ───────────────────────────────────────────────────────────────────────────────
{.br}
limit = #$:(0..):if coverage_type = builders_risk                ; Coverage limit
deductible = ##:if coverage_type = builders_risk                 ; Deductible amount
project_name = ::if coverage_type = builders_risk                ; Project name
project_address = @address:if coverage_type = builders_risk      ; Project location

{@certificate_coverage_line}

; ───────────────────────────────────────────────────────────────────────────────
; Other Limits (Generic)
; ───────────────────────────────────────────────────────────────────────────────
{.other_coverage}
each_occurrence = ##                                             ; Per occurrence limit
aggregate = ##                                                   ; Aggregate limit
deductible = ##                                                  ; Deductible amount

{@certificate_coverage_line}

; ═══════════════════════════════════════════════════════════════════════════════
; Certificate Holder
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate_holder}
; Required fields first
name = :                                     ; Holder name

; Optional fields
holder_id = :                                 ; Unique holder identifier
address = @address                            ; Holder address

{@certificate_holder}

; ───────────────────────────────────────────────────────────────────────────────
; Holder Status Flags (multiple can apply)
; ───────────────────────────────────────────────────────────────────────────────
certificate_holder = ?                        ; Basic certificate holder
additional_insured = ?                        ; Named as additional insured
loss_payee = ?                                ; Loss payee interest
lenders_loss_payable = ?                      ; Lender's loss payable
mortgagee = ?                                 ; Mortgagee interest
waiver_of_subrogation = ?                     ; Waiver of subrogation applies
primary_noncontributory = ?                   ; Primary and non-contributory

; ───────────────────────────────────────────────────────────────────────────────
; Contract Reference (for commercial certificates)
; ───────────────────────────────────────────────────────────────────────────────
contract_reference = :                                           ; Contract or agreement number
project_reference = :                                            ; Project identifier
job_number = :                                                   ; Job or work order number
location_reference = :                                           ; Location identifier

; ═══════════════════════════════════════════════════════════════════════════════
; Insurance Certificate
; ═══════════════════════════════════════════════════════════════════════════════

{@certificate}
; Required fields first
certificate_number = :                       ; Unique certificate number
issue_date = date                            ; Date certificate was issued

; Optional fields
certificate_id = :                            ; Internal certificate identifier
category = (commercial, personal)             ; Commercial or personal lines

; ───────────────────────────────────────────────────────────────────────────────
; Carriers
; ───────────────────────────────────────────────────────────────────────────────
carriers[] = @carrier                                            ; Insurers providing coverage

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Type
; ───────────────────────────────────────────────────────────────────────────────
certificate_type = (
    auto_id_card,                             ; Personal auto insurance card
    combined,                                 ; Combined liability and property
    custom,
    homeowners_dec,                           ; Homeowners declarations page
    liability,                                ; Evidence of liability coverage
    property,                                 ; Evidence of property coverage
    umbrella_dec,                             ; Personal umbrella declarations
    workers_compensation                      ; Evidence of WC coverage
)

revision_number = ##:(0..)                    ; Certificate revision number

; Producer/Agent (optional for personal ID cards)
{.producer}
name = :                                                         ; Producer/agency name
contact = :                                                      ; Contact person name
phone = *@phone                                                  ; Phone number
fax = *@phone                                                    ; Fax number
email = *@email                                                  ; Email address
address = @address                                               ; Producer address

{.producer}

{@certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Insured (Named Insured)
; ───────────────────────────────────────────────────────────────────────────────
{.insured}
name = :                                                        ; Named insured
dba = :                                                          ; Doing business as
address = @address                                               ; Insured address

{.insured}

{@certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Vehicle Information (for auto ID cards)
; ───────────────────────────────────────────────────────────────────────────────
{.vehicles[]}
year = ##:(1900..2100)                                           ; Model year
make = :                                                         ; Vehicle make
model = :                                                        ; Vehicle model
vin = *:(17)                                                     ; Vehicle identification number
plate_number = :                                                 ; License plate number
plate_state = :(2)                                               ; License plate state

{@certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Lines
; ───────────────────────────────────────────────────────────────────────────────
coverage_lines[] = @certificate_coverage_line                    ; List of coverage lines

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Holder(s) (primarily for commercial)
; ───────────────────────────────────────────────────────────────────────────────
holders[] = @certificate_holder                                  ; Certificate holders

; ───────────────────────────────────────────────────────────────────────────────
; Special Provisions / Description of Operations
; ───────────────────────────────────────────────────────────────────────────────
description_of_operations = :                                    ; Description of operations
project_description = :                                          ; Project description
location_description = :                                         ; Location description

; ───────────────────────────────────────────────────────────────────────────────
; Cancellation Notice
; ───────────────────────────────────────────────────────────────────────────────
cancellation_notice_days = ##:(0, 10, 15, 30, 45, 60, 90)        ; Days notice for cancellation
non_renewal_notice_days = ##:(0, 10, 30, 45, 60, 90)             ; Days notice for non-renewal
material_change_notice = ?                                       ; Material change notice required

; ───────────────────────────────────────────────────────────────────────────────
; Authorized Representative
; ───────────────────────────────────────────────────────────────────────────────
{.authorized_rep}
name = :                                                         ; Representative name
signature_date = date                                            ; Date signed
electronic_signature = ?                                         ; Electronic signature used

{@certificate}

; ───────────────────────────────────────────────────────────────────────────────
; Certificate Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, expired, superseded)                ; Certificate status
superseded_by = ::if status = superseded                         ; Superseding certificate number
supersedes = :                                                   ; Certificate this supersedes


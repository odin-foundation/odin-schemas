; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Health Insurance Marketplace Application Schema
; ═══════════════════════════════════════════════════════════════════════════════
; ACA Marketplace/Exchange application structures including household
; composition, income, and authorized representatives. Derived from 45 CFR
; Part 155 and the CMS Single Streamlined Application.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.application"
version = "1.0.0"
title = "Health Insurance Marketplace Application Schema"
description = "Marketplace application structures"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "CMS-10440 Single Streamlined Application"
source[0].url = "https://www.cms.gov/cciio/programs-and-initiatives/health-insurance-marketplaces"

source[1].authority = "GPO"
source[1].citation = "45 CFR 155.405 - Single streamlined application"
source[1].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-D/section-155.405"

source[2].authority = "CMS"
source[2].citation = "HealthCare.gov Application"
source[2].url = "https://www.healthcare.gov/quick-guide/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Marketplace application schema"
changelog[0].rationale = "Structure derived from 45 CFR 155.405 and CMS Single Streamlined Application"

; ═══════════════════════════════════════════════════════════════════════════════
; APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.405

{@application}
application_id = :                         ; Application ID
exchange_id = :                            ; Exchange identifier
exchange_type = (ffm, sbm, sbm_fp)         ; Exchange type
; ffm = Federally Facilitated Marketplace
; sbm = State-Based Marketplace
; sbm_fp = SBM using Federal Platform

; Application type
application_type = (change, new, renewal, sep)
coverage_year = ##:(2014..)                ; Coverage year

; Dates
{.dates}
created = date                             ; Application created
submitted = date                            ; Application submitted
last_modified = date                        ; Last modification

{@application}

; Primary contact - Per 45 CFR 155.410(d)
contact_name = :                           ; Contact name
phone = *@phone                             ; Phone
email = *@email                             ; Email
contact_preferences = @contact_preference   ; Contact method preferences
preferred_language = : "en"                 ; Preferred language

{@application}

; Authorized representative - Per 45 CFR 155.227
{.authorized_rep}
representative = ?                          ; Authorized representative
rep_name = :                                ; Rep name
rep_organization = :                        ; Organization if applicable
rep_phone = *@phone                         ; Rep phone
rep_type = (application_assister, authorized_rep, broker, navigator)

{@application}

; Household
household = @marketplace.household         ; Tax household
applicants[] = @application_member          ; All applicants

; Status
status = @status_record                     ; Application status tracking
status.status = (approved, denied, incomplete, pending, submitted, withdrawn)
substatus = :                               ; Detailed substatus

{@application}

; Verification status
{.verification}
all_verified = ?                            ; All verifications complete
pending_verifications[] = :                 ; Pending verification items
inconsistencies[] = :                       ; Data inconsistencies
resolution_deadline = date                  ; Resolution deadline

{@application}

; ═══════════════════════════════════════════════════════════════════════════════
; APPLICATION MEMBER
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.305

{@application_member}
member_id = :                              ; Member ID on application
applicant = @marketplace.applicant         ; Applicant information

; Relationship - Per 45 CFR 155.305(a)
{.relationship}
tax_filer = ?                               ; Is tax filer
relationship_to_filer = :                   ; Relationship to tax filer
claimed_as_dependent = ?                    ; Claimed as dependent
dependent_of = :                            ; Dependent of (if applicable)

{@application_member}

; Coverage request
{.coverage_request}
requesting_coverage = ?                     ; Requesting coverage
requesting_medicaid_chip = ?                ; Requesting Medicaid/CHIP assessment
requesting_aptc_csr = ?                     ; Requesting APTC/CSR

{@application_member}

; Income - Per 45 CFR 155.305(f)
income = @marketplace.income                ; Income information

; Current coverage - Per 45 CFR 155.305(f)(4)
coverage = @marketplace.coverage_info       ; Current coverage info

; Attestations - Per 45 CFR 155.405(c)
{.attestations}
us_citizen_national = ?                     ; US citizen or national
lawfully_present = ?                        ; Lawfully present
incarcerated = ?                            ; Currently incarcerated
state_resident = ?                          ; State resident
tax_filing_required = ?                     ; Required to file taxes
plans_to_file = ?                           ; Plans to file taxes

{@application_member}

; ═══════════════════════════════════════════════════════════════════════════════
; SHOP APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.710 - SHOP for small employers

{@shop_application}
application_id = :                         ; Application ID
exchange_id = :                            ; Exchange ID

; Employer information
{.employer}
employer_name = :                          ; Employer legal name
dba_name = :                                ; DBA name
ein = *:                                   ; Employer Identification Number
address = @marketplace.address             ; Business address
phone = *@phone                             ; Phone
email = *@email                             ; Email

{@shop_application}

; Eligibility - Per 45 CFR 155.710
{.eligibility}
state = :(2)                               ; Primary business state
employee_count = ##:(1..)                  ; Full-time equivalent employees
fte_calculation = ##:(0..)                  ; FTE count for eligibility
meets_small_employer = ?                    ; Meets small employer definition
offer_to_all_fte = ?                        ; Offers to all FTEs

{@shop_application}

; Contribution - Per 45 CFR 155.705
{.contribution}
contribution_type = (dollar, percent)       ; Contribution type
employee_contribution = #:(0..100)          ; Employee-only contribution
dependent_contribution = #:(0..100)         ; Dependent contribution
dollar_amount = #$:(0..)                    ; Dollar amount if fixed

{@shop_application}

; Plan selection
{.plan_selection}
selection_method = (employee_choice, single_carrier, single_plan)
metal_levels_offered[] = (bronze, gold, platinum, silver)
carriers_offered[] = :                      ; Carriers offered

{@shop_application}

; Dates
{.dates}
application_date = date                    ; Application date
effective_date = date                       ; Coverage effective date
plan_year_start = date                      ; Plan year start
plan_year_end = date                        ; Plan year end

{@shop_application}

; Status
status = @status_record                     ; SHOP application status
status.status = (active, approved, denied, pending, terminated)

{@shop_application}

; ═══════════════════════════════════════════════════════════════════════════════
; SHOP EMPLOYEE
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.715

{@shop_employee}
employee_id = :                            ; Employee ID
employer_id = :                            ; Employer application ID
applicant = @marketplace.applicant         ; Employee information

; Employment
{.employment}
full_time = ?                               ; Full-time employee
hours_per_week = ##:(0..80)                 ; Hours per week
hire_date = date                            ; Hire date
eligible_date = date                        ; Coverage eligible date
termination_date = date                     ; Termination date

{@shop_employee}

; Eligibility
{.eligibility}
waiting_period_met = ?                      ; Waiting period completed
eligible_for_coverage = ?                   ; Eligible for SHOP coverage

{@shop_employee}

; Coverage election
{.election}
waiving_coverage = ?                        ; Waiving coverage
waiver_reason = :                           ; Reason for waiver
enrolling_self = ?                          ; Enrolling self
enrolling_dependents = ?                    ; Enrolling dependents

{@shop_employee}

; Dependents
dependents[] = @marketplace.applicant       ; Dependent information

; ═══════════════════════════════════════════════════════════════════════════════
; RENEWAL APPLICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.335

{@renewal}
renewal_id = :                             ; Renewal ID
original_application_id = :                ; Original application
coverage_year = ##:(2014..)                ; New coverage year

; Renewal type - Per 45 CFR 155.335(a)
renewal_type = (active, automatic, passive)
; automatic = Auto-renewed by exchange
; passive = Passive renewal without action
; active = Enrollee actively renewed

; Data reuse
{.data_reuse}
data_from_prior = ?                         ; Using prior year data
data_updated = ?                            ; Data updated this year
income_verified = ?                         ; Income re-verified

{@renewal}

; Changes reported
{.changes}
household_change = ?                        ; Household composition changed
income_change = ?                           ; Income changed
address_change = ?                          ; Address changed
coverage_change = ?                         ; Other coverage changed

{@renewal}

; Re-determination
{.redetermination}
aptc_recalculated = ?                        ; APTC recalculated
new_aptc_amount = #$:(0..)                   ; New APTC amount
csr_recalculated = ?                         ; CSR recalculated
new_csr_level = ##:(0..94)                   ; New CSR level

{@renewal}

; Plan selection
{.plan}
same_plan = ?                               ; Keeping same plan
plan_available = ?                          ; Prior plan still available
auto_enrolled_crosswalk = ?                 ; Auto-enrolled in crosswalk plan
active_plan_selection = ?                   ; Actively selected plan

{@renewal}

; Dates
{.dates}
notice_date = date                          ; Renewal notice date
deadline = date                             ; Action deadline
submitted = date                            ; Renewal submitted

{@renewal}

; ═══════════════════════════════════════════════════════════════════════════════
; CHANGE REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.330

{@change_request}
request_id = :                             ; Request ID
application_id = :                         ; Application ID
request_date = date                        ; Request date

; Change type
change_type = (address, coverage, dependent, income, other)
change_description = :                      ; Description of change

; Prior values
{.prior}
prior_value = :                             ; Prior value
new_value = :                               ; New value
effective_date = date                       ; When change occurred

{@change_request}

; Impact assessment
{.impact}
requires_redetermination = ?                ; Requires new determination
aptc_impact = ?                             ; Impacts APTC
csr_impact = ?                              ; Impacts CSR
medicaid_chip_impact = ?                    ; Impacts Medicaid/CHIP eligibility

{@change_request}

; Processing
{.processing}
processed = ?                               ; Change processed
processed_date = date                       ; Date processed
new_determination = ?                       ; New eligibility determination made

{@change_request}

; ═══════════════════════════════════════════════════════════════════════════════
; APPEAL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.500-555

{@appeal}
appeal_id = :                              ; Appeal ID
application_id = :                         ; Associated application
appellant_id = :                           ; Appellant

; Appeal basis
appeal_type = (eligibility, enrollment, other, sep)
appealed_determination = :                  ; Determination being appealed
appeal_reason = :                           ; Reason for appeal

; Filing - Per 45 CFR 155.505
{.filing}
filed_date = date                          ; Date filed
timely = ?                                  ; Filed within deadline
filing_method = (mail, online, phone)       ; How filed
expedited_requested = ?                     ; Expedited review requested
expedited_granted = ?                       ; Expedited granted

{@appeal}

; Hearing - Per 45 CFR 155.535
{.hearing}
hearing_scheduled = ?                       ; Hearing scheduled
hearing_date = date                         ; Hearing date
hearing_type = (in_person, phone, written)  ; Hearing type
hearing_location = :                        ; Location if in-person

{@appeal}

; Resolution - Per 45 CFR 155.545
resolution = @status_record                 ; Appeal resolution tracking
resolution.status = (affirmed, dismissed, pending, reversed, withdrawn)
implementation_date = date                  ; Date to implement decision

{@appeal}

; HHS appeal - Per 45 CFR 155.520
{.hhs_appeal}
escalated_to_hhs = ?                        ; Escalated to HHS
hhs_appeal_date = date                      ; HHS appeal date
hhs_decision = (affirmed, remanded, reversed)

{@appeal}


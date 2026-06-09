; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Special Enrollment Period (SEP) Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Special Enrollment Period structures including qualifying life events,
; verification requirements, and enrollment windows. Derived from 45 CFR
; 155.420 and CMS SEP guidance.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as marketplace

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.marketplace.sep"
version = "1.0.0"
title = "Special Enrollment Period Schema"
description = "SEP structures and qualifying events"

{$derivation}
source[0].authority = "GPO"
source[0].citation = "45 CFR 155.420 - Special enrollment periods"
source[0].url = "https://www.ecfr.gov/current/title-45/subtitle-A/subchapter-B/part-155/subpart-E/section-155.420"

source[1].authority = "CMS"
source[1].citation = "Special Enrollment Period Reference Chart"
source[1].url = "https://www.healthcare.gov/help/special-enrollment-period/"

source[2].authority = "CMS"
source[2].citation = "SEP Verification Process"
source[2].url = "https://www.cms.gov/cciio/Resources/Regulations-and-Guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial SEP schema"
changelog[0].rationale = "Structure derived from 45 CFR 155.420 and CMS SEP guidance"

; ═══════════════════════════════════════════════════════════════════════════════
; SEP REQUEST
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420

{@request}
sep_id = :                                 ; SEP request ID
application_id = :                         ; Associated application
applicant_id = :                           ; Applicant requesting SEP
request_date = date                        ; Date SEP requested

; Qualifying event
qualifying_event = @qualifying_event       ; Qualifying event details

; SEP type - Per 45 CFR 155.420
sep_type = (birth_adoption, coverage_loss, error, income_change, lawful_presence, marriage_divorce, medicaid_chip_loss, move, other, permanent_move, plan_error, qle, system_error)

; Affected members
affected_members[] = :                      ; Members eligible for SEP

; SEP period
{.period}
event_date = date                          ; Date of qualifying event
sep_start = date                            ; SEP window start
sep_end = date                              ; SEP window end
days_from_event = ##:(60..)                 ; Days from event allowed

{@request}

; Effective date options - Per 45 CFR 155.420(b)
{.effective}
prospective_only = ?                        ; Prospective effective date only
first_of_month = ?                          ; First of month following enrollment
fifteenth_rule = ?                          ; 15th of month rule applies
requested_effective = date                  ; Requested effective date
actual_effective = date                     ; Actual effective date

{@request}

; Verification - Per CMS SEP verification
{.verification}
pre_enrollment_verification = ?             ; Pre-enrollment verification required
verification_required = ?                   ; Post-enrollment verification required
verification_type = :                       ; Type of verification
documents_requested[] = :                   ; Documents requested
verification_deadline = date                ; Deadline for verification

{@request}

; Status
{.status}
status = (approved, denied, expired, pending, withdrawn)
denial_reason = :                           ; Reason if denied
appeal_available = ?                        ; Appeal available

{@request}

; ═══════════════════════════════════════════════════════════════════════════════
; QUALIFYING EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)

{@qualifying_event}
event_type = :                             ; Event type code
event_date = date                          ; Date of event
description = :                             ; Event description

; Event category - Per 45 CFR 155.420(d)
category = (coverage, eligibility, error, life, other)

; Event specifics based on type
coverage_loss = @coverage_loss_event        ; Loss of MEC
life_event = @life_event                    ; Marriage/birth/etc.
move_event = @move_event                    ; Permanent move
eligibility_change = @eligibility_change_event ; Eligibility changes
plan_error = @plan_error_event              ; Plan/exchange errors

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE LOSS EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)(1)

{@coverage_loss_event}
prior_coverage_type = (chip, cobra, employer, individual, medicaid, medicare, military, other, retiree, student)
coverage_end_date = date                   ; Date coverage ends/ended

; Loss reason
{.reason}
reason = (aging_out, cobra_exhaustion, cost, death_policyholder, divorce, employer_stopped, employment_change, ineligibility, job_loss, move, non_renewal, plan_discontinued, reduction_hours, voluntary)
involuntary_loss = ?                        ; Involuntary loss

{@coverage_loss_event}

; Employer coverage loss specifics
{.employer}
employer_name = :                           ; Employer name
employer_ein = :                            ; EIN
last_day_employed = date                    ; Last day of employment
cobra_offered = ?                           ; COBRA offered
cobra_elected = ?                           ; COBRA elected
cobra_end_date = date                       ; COBRA exhaustion date

{@coverage_loss_event}

; Documentation
documentation_type = (cobra_notice, employer_letter, termination_notice, other)

; ═══════════════════════════════════════════════════════════════════════════════
; LIFE EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)(2)

{@life_event}
event_type = (adoption, birth, custody, death, divorce, foster_placement, marriage)
event_date = date                          ; Event date

; Marriage - Per 45 CFR 155.420(d)(2)(i)
{.marriage}
marriage_date = date                        ; Marriage date
spouse_has_coverage = ?                     ; Spouse had prior coverage
adding_spouse = ?                           ; Adding spouse to coverage

{@life_event}

; Birth/adoption - Per 45 CFR 155.420(d)(2)(i)
{.birth_adoption}
child_dob = date                            ; Child date of birth
adoption_date = date                        ; Adoption/placement date
child_name = :                              ; Child name
adding_child = ?                            ; Adding child to coverage

{@life_event}

; Divorce - Per 45 CFR 155.420(d)(2)(i)
{.divorce}
divorce_date = date                         ; Divorce date
losing_coverage = ?                         ; Losing coverage through ex-spouse

{@life_event}

; Death - Per 45 CFR 155.420(d)(2)(i)
{.death}
date_of_death = date                        ; Date of death
relationship = :                            ; Relationship to deceased
losing_coverage = ?                         ; Losing coverage through deceased

{@life_event}

; Documentation
documentation_type = (adoption_decree, birth_certificate, court_order, death_certificate, marriage_certificate, other)

; ═══════════════════════════════════════════════════════════════════════════════
; MOVE EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)(7)

{@move_event}
move_date = date                           ; Date of move

; Prior address
{.prior_address}
address = @marketplace.address              ; Prior address
rating_area = :                             ; Prior rating area
had_coverage = ?                            ; Had coverage at prior address

{@move_event}

; New address
{.new_address}
address = @marketplace.address              ; New address
rating_area = :                             ; New rating area
different_service_area = ?                  ; Different service area

{@move_event}

; Move type - Per 45 CFR 155.420(d)(7)
{.type}
permanent_move = ?                          ; Permanent move
relocating_for_work = ?                     ; Work relocation
student_move = ?                            ; Student move
move_from_foreign = ?                       ; Move from foreign country
moved_into_service_area = ?                 ; Moved into plan service area
gained_access_to_qhp = ?                    ; Gained access to QHP

{@move_event}

; Documentation
documentation_type = (lease, mortgage, prior_coverage_proof, utility_bill, other)

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY CHANGE EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)(4)-(6)

{@eligibility_change_event}
change_type = (aptc_change, citizenship_change, csr_change, income_change, lawful_presence, medicaid_chip_denial, medicaid_chip_loss, newly_eligible)
change_date = date                         ; Date of change

; Income change - Per 45 CFR 155.420(d)(6)
{.income}
prior_fpl_percent = #:(0..)                 ; Prior income % FPL
new_fpl_percent = #:(0..)                   ; New income % FPL
newly_aptc_eligible = ?                     ; Became APTC eligible
newly_csr_eligible = ?                      ; Became CSR eligible
lost_aptc_csr = ?                           ; Lost APTC/CSR

{@eligibility_change_event}

; Lawful presence - Per 45 CFR 155.420(d)(3)
{.lawful_presence}
became_lawfully_present = ?                 ; Became lawfully present
immigration_status = :                      ; Immigration status
date_lawful = date                          ; Date became lawful

{@eligibility_change_event}

; Medicaid/CHIP - Per 45 CFR 155.420(d)(1)
{.medicaid_chip}
lost_medicaid = ?                           ; Lost Medicaid
lost_chip = ?                               ; Lost CHIP
ineligibility_date = date                   ; Date became ineligible
denial_date = date                          ; Date of denial

{@eligibility_change_event}

; Documentation
documentation_type = (denial_notice, eligibility_notice, immigration_document, income_verification, termination_notice, other)

; ═══════════════════════════════════════════════════════════════════════════════
; PLAN ERROR EVENT
; ═══════════════════════════════════════════════════════════════════════════════
; Per 45 CFR 155.420(d)(4)

{@plan_error_event}
error_type = (exchange_error, issuer_error, navigator_error, plan_discontinuation, system_error)
error_date = date                          ; Date error occurred/discovered

; Exchange/system error - Per 45 CFR 155.420(d)(4)
{.system}
prevented_enrollment = ?                    ; Error prevented enrollment
incorrect_enrollment = ?                    ; Enrolled incorrectly
incorrect_eligibility = ?                   ; Eligibility determined incorrectly
incorrect_aptc = ?                          ; APTC calculated incorrectly
system_outage = ?                           ; System outage
error_description = :                       ; Description of error

{@plan_error_event}

; Issuer error
{.issuer}
issuer_id = :                               ; Issuer involved
misinformation = ?                          ; Provided misinformation
enrollment_error = ?                        ; Enrollment processing error
premium_error = ?                           ; Premium billing error

{@plan_error_event}

; Plan discontinuation - Per 45 CFR 155.420(d)(1)(ii)
{.discontinuation}
plan_discontinued = ?                       ; Plan being discontinued
discontinuation_date = date                 ; Discontinuation date
crosswalk_plan_id = :                       ; Crosswalk plan if any

{@plan_error_event}

; ═══════════════════════════════════════════════════════════════════════════════
; SEP VERIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per CMS SEP verification guidance

{@verification}
sep_id = :                                 ; SEP request ID
verification_type = (post_enrollment, pre_enrollment)

; Required documents
{.documents}
document_type = :                           ; Document type required
received = ?                                ; Document received
received_date = date                        ; Date received
acceptable = ?                              ; Document acceptable

{@verification}

; Verification result
{.result}
verified = ?                                ; SEP verified
verification_date = date                    ; Verification date
verifier = :                                ; Who verified

{@verification}

; Non-verification consequences - Per CMS guidance
{.consequences}
enrollment_terminated = ?                   ; Enrollment terminated
termination_date = date                     ; Termination effective date
aptc_repayment = ?                          ; APTC must be repaid
notice_sent = ?                             ; Notice sent

{@verification}

; ═══════════════════════════════════════════════════════════════════════════════
; SEP TYPE DEFINITIONS
; ═══════════════════════════════════════════════════════════════════════════════
; Reference table for SEP types

{@sep_type_definition}
sep_code = :                               ; SEP type code
name = :                                   ; SEP type name
category = (coverage_loss, eligibility, error, life_event, move, other)
regulation = :                              ; CFR citation

; Timing rules
{.timing}
days_before_event = ##:(0..60)              ; Days before event allowed
days_after_event = ##:(0..60)               ; Days after event allowed
prospective_only = ?                        ; Prospective effective dates only

{@sep_type_definition}

; Verification
{.verification}
pre_enrollment_verification = ?             ; Pre-enrollment verification
post_enrollment_verification = ?            ; Post-enrollment verification
required_documents[] = :                    ; Required document types

{@sep_type_definition}

; Effective date rules
{.effective_date}
first_of_month = ?                          ; First of following month
fifteenth_rule = ?                          ; 15th of month rule
event_date = ?                              ; Date of event
retroactive_allowed = ?                     ; Retroactive effective date

{@sep_type_definition}


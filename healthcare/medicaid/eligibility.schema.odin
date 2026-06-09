; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Medicaid Eligibility Schema
; ═══════════════════════════════════════════════════════════════════════════════
; MAGI and categorical Medicaid eligibility determination including income
; calculation, household composition, and eligibility group assignment.
; Derived from CMS MAGI guidance and 42 CFR Part 435.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./types.schema.odin" as medicaid

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.healthcare.medicaid.eligibility"
version = "1.0.0"
title = "Medicaid Eligibility Schema"
description = "MAGI and categorical Medicaid eligibility determination"

{$derivation}
source[0].authority = "CMS"
source[0].citation = "MAGI Conversion Methodology - Final Rule"
source[0].url = "https://www.medicaid.gov/medicaid/eligibility/index.html"

source[1].authority = "GPO"
source[1].citation = "42 CFR 435.603 - Application of MAGI-based financial methods"
source[1].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-435/subpart-J/section-435.603"

source[2].authority = "GPO"
source[2].citation = "42 CFR Part 435 Subparts B-H - Eligibility Groups"
source[2].url = "https://www.ecfr.gov/current/title-42/chapter-IV/subchapter-C/part-435"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial Medicaid eligibility schema"
changelog[0].rationale = "Structure derived from CMS MAGI guidance and 42 CFR Part 435"

; ═══════════════════════════════════════════════════════════════════════════════
; ELIGIBILITY DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.911

{@determination}
determination_id = :                        ; Determination ID
member = @medicaid.member                   ; Applicant/member
determination_date = date                   ; Date of determination

; Overall result
eligible = ?                                ; Eligible for Medicaid
eligibility_group = @medicaid.eligibility_group:if eligible = true
benefit_package = @medicaid.benefit_package:if eligible = true
effective_date = date:if eligible = true     ; Coverage effective date

; Denial information
denial_reason = :                            ; Reason if ineligible
denial_code = :                              ; Denial reason code
appeal_rights = ?                            ; Appeal rights apply

; Methodology used
methodology = (magi, non_magi)              ; Eligibility methodology

; ───────────────────────────────────────────────────────────────────────────────
; MAGI Determination - Per 42 CFR 435.603
; ───────────────────────────────────────────────────────────────────────────────
magi_determination = @magi_determination:if methodology = magi

; ───────────────────────────────────────────────────────────────────────────────
; Non-MAGI Determination - Per 42 CFR 435.601
; ───────────────────────────────────────────────────────────────────────────────
non_magi_determination = @non_magi_determination:if methodology = non_magi

; ═══════════════════════════════════════════════════════════════════════════════
; MAGI DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.603 - MAGI-based financial methods

{@magi_determination}
household = @medicaid.household             ; MAGI household

; Income calculation - Per 42 CFR 435.603(e)
{.income}
gross_magi = #$:(0..)                        ; Gross MAGI
standard_deduction = #$:(0..)                ; 5% disregard
net_magi = #$:(0..)                          ; Net MAGI for comparison
fpl_percent = #:(0..)                       ; Income as percent of FPL
household_size = ##:(1..)                   ; Household size used

{@magi_determination}

; FPL thresholds by group - Per state plan
{.thresholds}
applicable_fpl = #:(0..400)                 ; Applicable FPL threshold
threshold_source = :                         ; Source (state plan, etc.)
income_under_threshold = ?                   ; Income below threshold

{@magi_determination}

; Category evaluation - Per 42 CFR 435.110-119
{.category}
evaluated_categories[] = @magi_category_eval ; Categories evaluated
qualifying_category = :                      ; Qualifying category

{@magi_determination}

; Exceptions
{.exceptions}
pregnant_exception = ?                       ; Pregnancy income exception
newborn_exception = ?                        ; Newborn deemed eligible
former_foster_exception = ?                  ; Former foster care exception

{@magi_determination}

{@magi_category_eval}
category = (adult, child, chip, former_foster, parent, pregnant, targeted_low_income_child)
fpl_limit = #:(0..400)                       ; FPL limit for category
meets_criteria = ?                           ; Meets non-financial criteria
income_eligible = ?                          ; Income eligible
overall_eligible = ?                         ; Overall eligible for category

; Category-specific criteria
{.criteria}
age_met = ?                                  ; Age criteria met
relationship_met = ?                         ; Relationship criteria met
pregnancy_met = ?                            ; Pregnancy criteria (if applicable)
other_coverage_met = ?                       ; Other coverage criteria

{@magi_category_eval}

; ═══════════════════════════════════════════════════════════════════════════════
; NON-MAGI DETERMINATION
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.601 - Non-MAGI financial methods

{@non_magi_determination}
; Income - Per 42 CFR 435.831
{.income}
gross_monthly = #$:(0..)                     ; Gross monthly income
disregards = #$:(0..)                        ; Income disregards
countable_income = #$:(0..)                  ; Countable income
income_limit = #$:(0..)                      ; Applicable income limit
income_eligible = ?                          ; Income eligible

{@non_magi_determination}

; Resources - Per 42 CFR 435.840
{.resources}
gross_resources = #$:(0..)                   ; Gross resources
exempt_resources = #$:(0..)                  ; Exempt resources
countable_resources = #$:(0..)               ; Countable resources
resource_limit = #$:(0..)                    ; Applicable limit
resource_eligible = ?                        ; Resource eligible

{@non_magi_determination}

; Categorical eligibility - Per 42 CFR 435.120-137
{.category}
category = (aged, blind, disabled, medically_needy, ssi, ssi_related)
categorical_eligible = ?                     ; Meets categorical requirements

; SSI linkage
ssi_recipient = ?                            ; Current SSI recipient
ssi_state = ?                                ; SSI state (1634, 209b, SSI criteria)

; ABD criteria
aged = ?                                     ; Age 65+
blind = ?                                    ; Meets blindness criteria
disabled = ?                                 ; Meets disability criteria
disability_determination = :                 ; Disability determination reference

{@non_magi_determination}

; Medically needy - Per 42 CFR 435.831
{.medically_needy}
medically_needy_state = ?                    ; State has MN program
medically_needy_eligible = ?                 ; MN eligible
spenddown_amount = #$:(0..)                  ; Spenddown amount
spenddown_period = :                         ; Spenddown period
medical_expenses = #$:(0..)                  ; Medical expenses applied

{@non_magi_determination}

; ═══════════════════════════════════════════════════════════════════════════════
; PRESUMPTIVE ELIGIBILITY
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.1101-1103

{@presumptive_eligibility}
pe_id = :                                   ; PE determination ID
member = @medicaid.member                   ; Member
pe_type = (child, hospital, pregnant, qualified_entity)

; Determination
determination_date = date                   ; PE determination date
qualified_entity = :                         ; Qualified entity name
qualified_entity_id = :                      ; Entity ID

; PE period
{.period}
effective_date = date                       ; PE coverage start
end_date = date                             ; PE coverage end
maximum_days = ##:(0..60)                    ; Maximum PE days

{@presumptive_eligibility}

; Income screening
{.income}
income_attested = #$:(0..)                   ; Self-attested income
household_size = ##:(1..)                    ; Household size
appears_eligible = ?                         ; Appears income eligible

{@presumptive_eligibility}

; Full application status
{.application}
full_application_submitted = ?               ; Full application filed
submission_date = date                       ; Date submitted
determination_pending = ?                    ; Awaiting determination

{@presumptive_eligibility}

; ═══════════════════════════════════════════════════════════════════════════════
; EX PARTE RENEWAL
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.916 - Administrative renewal

{@ex_parte_renewal}
member_id = :                               ; Member ID
renewal_date = date                         ; Renewal date

; Data sources checked
{.data_sources}
wage_data = ?                                ; Wage data checked
tax_data = ?                                 ; Tax data checked
ssi_data = ?                                 ; SSI data checked
snap_tanf_data = ?                           ; SNAP/TANF data checked
other_state_data = ?                         ; Other state Medicaid data

{@ex_parte_renewal}

; Result
{.result}
renewed_ex_parte = ?                         ; Renewed without contact
eligibility_group = :                        ; Renewed eligibility group
requires_renewal_form = ?                    ; Renewal form needed
reason_form_needed = :                       ; Reason form required

{@ex_parte_renewal}

; ═══════════════════════════════════════════════════════════════════════════════
; VERIFICATION RESULTS
; ═══════════════════════════════════════════════════════════════════════════════
; Per 42 CFR 435.940-965

{@verification_results}
determination_id = :                        ; Associated determination
verification_date = date                    ; Verification date

; Required verifications
{.verifications}
citizenship = @medicaid.verification         ; Citizenship verification
identity = @medicaid.verification            ; Identity verification
ssn = @medicaid.verification                 ; SSN verification
residency = @medicaid.verification           ; Residency verification
income = @medicaid.verification              ; Income verification

{@verification_results}

; Overall status
all_verified = ?                             ; All items verified
pending_items[] = :                          ; Items still pending
rop_active = ?                               ; Reasonable opportunity period active


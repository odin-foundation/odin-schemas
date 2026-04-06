; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Term Life Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Term life insurance extending the base life policy with term-specific fields
; including level term periods, renewable and convertible provisions, decreasing
; term, and return of premium options.
; ═══════════════════════════════════════════════════════════════════════════════

@import "./policy.schema.odin" as life
@import "../common/life-annuity/types.schema.odin" as la

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.life.term"
version = "1.0.0"
title = "Term Life Insurance Schema"
description = "Term life insurance extending base policy with term-specific fields"

{$derivation}
methodology = "industry_practice"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-15
changelog[0].change = "Initial term life insurance schema"
changelog[0].rationale = "Term-specific fields extending base life policy"

; ═══════════════════════════════════════════════════════════════════════════════
; Term Life Policy
; ═══════════════════════════════════════════════════════════════════════════════

{@policy}
= @life.policy                                ; Inherit all base life policy fields

; Required term-specific fields
term_type = !(annual_renewable, decreasing, level, return_of_premium)  ; Term type
term_years = !##                              ; Term length in years

; ───────────────────────────────────────────────────────────────────────────────
; Term Expiration
; ───────────────────────────────────────────────────────────────────────────────
term_end_date = date                          ; Date term expires
years_remaining = ##:(0..40)                  ; Years remaining in term

; ───────────────────────────────────────────────────────────────────────────────
; Renewal Options
; ───────────────────────────────────────────────────────────────────────────────
{.renewal}
guaranteed_renewable = ?                      ; Guaranteed renewable option
max_renewal_age = ##:(65..95)                 ; Maximum age for renewal
renewable = ?                                 ; Can be renewed
renewal_premium = #$:(0..)                    ; Premium at renewal (if known)

{@policy}

; ───────────────────────────────────────────────────────────────────────────────
; Conversion Options
; ───────────────────────────────────────────────────────────────────────────────
{.conversion}
available = ?                                 ; Conversion option available
available_products[] = :                      ; Products available for conversion
deadline = date                               ; Last date to convert
exercised = ?                                 ; Conversion has been exercised
max_conversion_age = ##:(55..80)              ; Maximum age for conversion
max_conversion_amount = #$:(0..)              ; Maximum amount convertible
min_conversion_amount = #$:(0..)              ; Minimum amount convertible
partial_allowed = ?                           ; Partial conversion allowed

{@policy}

; ═══════════════════════════════════════════════════════════════════════════════
; Level Term (Most common term product)
; ═══════════════════════════════════════════════════════════════════════════════
; Fixed death benefit and premium for the term period

{@level_term}
= @policy

; Set term type
term_type = !(level)

; Level term specific
{.level}
guaranteed_level_years = ##                   ; Years premium is guaranteed level
post_level_premium = #$:(0..)                 ; Premium after level period ends

{@level_term}

; ═══════════════════════════════════════════════════════════════════════════════
; Decreasing Term
; ═══════════════════════════════════════════════════════════════════════════════
; Death benefit decreases over time (often tied to mortgage balance)

{@decreasing_term}
= @policy

; Set term type
term_type = !(decreasing)

; Decreasing term specific
{.decreasing}
decrease_method = (fixed_amount, fixed_percentage, mortgage_schedule)  ; How DB decreases
decrease_frequency = (annual, monthly)        ; How often DB decreases
decrease_start_year = ##                      ; Policy year decreases begin
initial_amount = #$:(0..)                     ; Initial death benefit
minimum_amount = #$:(0..)                     ; Minimum death benefit
current_amount = #$:(0..)                     ; Current death benefit
mortgage_amount = #$:(0..)                    ; Original mortgage amount (if mortgage term)
mortgage_interest_rate = #                    ; Mortgage interest rate

{@decreasing_term}

; ═══════════════════════════════════════════════════════════════════════════════
; Annual Renewable Term (ART)
; ═══════════════════════════════════════════════════════════════════════════════
; Renews each year with increasing premium

{@annual_renewable_term}
= @policy

; Set term type
term_type = !(annual_renewable)

; ART specific
{.art}
current_year_premium = #$:(0..)               ; Current year premium
initial_premium = #$:(0..)                    ; First year premium
max_issue_age = ##:(50..80)                   ; Maximum issue age
next_year_premium = #$:(0..)                  ; Next year premium (if known)
premium_schedule[] = @art_premium_year        ; Multi-year premium schedule

{@annual_renewable_term}

{@art_premium_year}
age = !##:(18..100)                           ; Attained age
premium = !#$:(0..)                           ; Premium for that age

; ═══════════════════════════════════════════════════════════════════════════════
; Return of Premium Term
; ═══════════════════════════════════════════════════════════════════════════════
; Returns all premiums if insured survives term period

{@return_of_premium}
= @policy

; Set term type
term_type = !(return_of_premium)

; ROP specific
{.rop}
graduated_return = ?                          ; Graduated return schedule
premiums_paid = #$:(0..)                      ; Total premiums paid to date
return_amount = #$:(0..)                      ; Amount to be returned at term end
return_schedule[] = @rop_schedule             ; Graduated return schedule

{@return_of_premium}

{@rop_schedule}
year = !##                                    ; Policy year
return_percent = !#:(0..100)                  ; Percentage of premiums returned

; ═══════════════════════════════════════════════════════════════════════════════
; Group Term Life
; ═══════════════════════════════════════════════════════════════════════════════
; Employer-sponsored group term coverage

{@group_term}
= @policy

; Group-specific fields
{.group}
certificate_number = !:                       ; Individual certificate number
class = :                                     ; Employee class
coverage_multiple = #:(0..10)                 ; Multiple of salary
dependent_coverage = ?                        ; Includes dependent coverage
employer_name = :                             ; Employer name
employer_paid = ?                             ; Employer pays premium
master_policy = !:                            ; Master policy number
portability = ?                               ; Coverage can be ported
salary_used = #$:(0..)                        ; Salary used for coverage calculation
supplement_amount = #$:(0..)                  ; Supplemental coverage amount
voluntary = ?                                 ; Voluntary (employee-elected)

{@group_term}

; ───────────────────────────────────────────────────────────────────────────────
; Dependent Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.spouse}
coverage_amount = #$:(0..)                    ; Spouse coverage amount
date_of_birth = *date                         ; Spouse date of birth
name = :                                      ; Spouse name

{.child}
coverage_amount = #$:(0..)                    ; Per child coverage amount
max_age = ##:(18..26)                         ; Maximum child age

{@group_term}


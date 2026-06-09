; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Government Vital Records - Civil Records Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Civil vital records including birth, death, marriage, divorce, adoption,
; and name change certificates. Covers certificate issuance, amendments,
; certified copy requests, and jurisdiction-specific registration details.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.government.vital-records.civil"
version = "1.0.0"
title = "Civil Vital Records"
description = "Birth, death, marriage, divorce, adoption, and name change certificates"

{$derivation}
source[0].authority = "National Center for Health Statistics"
source[0].citation = "National Vital Statistics System (NVSS)"
source[0].url = "https://www.cdc.gov/nchs/nvss/index.htm"
source[0].accessed = 2025-12-21

source[1].authority = "State Vital Records Offices"
source[1].citation = "State Vital Records Requirements"
source[1].url = "https://www.cdc.gov/nchs/w2w/index.htm"
source[1].accessed = 2025-12-21

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial vital records schema"
changelog[0].rationale = "Vital records per NVSS and state requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; BIRTH CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════

{@birth_certificate}
= @types.audit_info

certificate_number = :
file_number = :
state_of_birth = :(2)
county_of_birth = :
city_of_birth = :

; Child Information
{.child}
first_name = :
middle_name = :
last_name = :
date_of_birth = *date
time_of_birth = time
sex = (female, male, unknown)
plurality = (quadruplet, quintuplet, single, triplet, twin)
birth_order = ##:(1..) 1

{@birth_certificate}
; Birth Location
{.birth_location}
facility_name = :
facility_address = @address
birth_place_type = (birthing_center, home, hospital, other)

{@birth_certificate}
; Mother Information
{.mother}
first_name = :
middle_name = :
maiden_name = :
married_name = :
date_of_birth = *date
birthplace_state = :(2)
birthplace_country = :(2..3)
residence_address = @address
education_level = (
    "8th_grade_or_less",
    "9th_to_12th_no_diploma",
    associate_degree,
    bachelors_degree,
    doctorate_or_professional,
    high_school_graduate_or_ged,
    masters_degree,
    some_college_credit_no_degree
)
race[] = :
hispanic_origin = ?
prenatal_care_month = ##:(1..9)
number_prenatal_visits = ##:(0..)
previous_live_births = ##:(0..)

{@birth_certificate}
; Father Information
{.father}
first_name = :
middle_name = :
last_name = :
date_of_birth = *date
birthplace_state = :(2)
birthplace_country = :(2..3)
education_level = (
    "8th_grade_or_less",
    "9th_to_12th_no_diploma",
    associate_degree,
    bachelors_degree,
    doctorate_or_professional,
    high_school_graduate_or_ged,
    masters_degree,
    some_college_credit_no_degree
)
race[] = :
hispanic_origin = ?

{@birth_certificate}
; Certification
{.certifier}
certifier_name = :
certifier_title = :
certification_date = date

{@birth_certificate}
; Registrar
{.registrar}
registrar_name = :
registration_date = date

{@birth_certificate}
; Amendments
amended = ?
{.amendments[]}
amendment_date = date
amendment_description = :
amended_by = :

{@birth_certificate}
; ═══════════════════════════════════════════════════════════════════════════════
; DEATH CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════

{@death_certificate}
= @types.audit_info

certificate_number = :
file_number = :
state_of_death = :(2)
county_of_death = :

; Decedent Information
{.decedent}
first_name = :
middle_name = :
last_name = :
suffix = :
sex = (female, male, unknown)
date_of_birth = *date
date_of_death = *date
time_of_death = time
age_at_death = ##:(0..)
ssn = *:format ssn
marital_status = (divorced, married, never_married, widowed)
surviving_spouse_name = :
father_name = :
mother_maiden_name = :
education_level = :
usual_occupation = :
kind_of_business = :
race[] = :
hispanic_origin = ?

{@death_certificate}
; Place of Death
{.death_location}
facility_name = :
facility_address = @address
death_location_type = (decedent_home, er, hospice_facility, inpatient, nursing_home, other)
county = :
city = :
inside_city_limits = ?

{@death_certificate}
; Residence
residence_address = @address
residence_inside_city_limits = ?

; Cause of Death
{.cause_of_death}
immediate_cause = :
due_to_a = :
due_to_b = :
due_to_c = :
other_significant_conditions = :
manner_of_death = (accident, homicide, natural, pending, suicide, undetermined)
autopsy_performed = ?
autopsy_findings_available = ?
tobacco_use_contributed = ?

{@death_certificate}
; Injury Information (if applicable)
{.injury}
injury_occurred = ?
injury_date = date:if injury_occurred = true
injury_time = time:if injury_occurred = true
injury_place = :if injury_occurred = true
injury_description = :if injury_occurred = true
injury_at_work = ?:if injury_occurred = true
transportation_injury = ?:if injury_occurred = true

{@death_certificate}
; Certifier
{.certifier}
certifier_type = (coroner, medical_examiner, other, physician, pronouncing_physician)
certifier_name = :
certifier_license_number = :
certification_date = date

{@death_certificate}
; Disposition
{.disposition}
method = (burial, cremation, donation, entombment, other, removal_from_state)
disposition_place_name = :
disposition_address = @address
funeral_facility_name = :
funeral_facility_address = @address

{@death_certificate}
; Registrar
registrar_name = :
registration_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; MARRIAGE CERTIFICATE
; ═══════════════════════════════════════════════════════════════════════════════

{@marriage_certificate}
= @types.audit_info

certificate_number = :
file_number = :
state_of_marriage = :(2)
county_of_marriage = :

; Marriage Information
{.marriage}
marriage_date = date
marriage_location = @address
ceremony_type = (civil, religious)
officiant_name = :
officiant_title = :

{@marriage_certificate}
; Party A
{.party_a}
first_name = :
middle_name = :
last_name = :
suffix = :
prior_marital_status = (divorced, never_married, widowed)
date_of_birth = *date
age_at_marriage = ##:(0..)
birthplace_state = :(2)
birthplace_country = :(2..3)
ssn = *:format ssn
residence_address = @address
father_name = :
mother_maiden_name = :
education_level = :
race[] = :
hispanic_origin = ?

{@marriage_certificate}
; Party B
{.party_b}
first_name = :
middle_name = :
last_name = :
suffix = :
prior_marital_status = (divorced, never_married, widowed)
date_of_birth = *date
age_at_marriage = ##:(0..)
birthplace_state = :(2)
birthplace_country = :(2..3)
ssn = *:format ssn
residence_address = @address
father_name = :
mother_maiden_name = :
education_level = :
race[] = :
hispanic_origin = ?

{@marriage_certificate}
; License Information
{.license}
license_number = *:
license_issue_date = date
license_issue_county = :

{@marriage_certificate}
; Witnesses
{.witnesses[]}
name = :
address = @address

{@marriage_certificate}
; Registrar
registrar_name = :
registration_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; DIVORCE DECREE
; ═══════════════════════════════════════════════════════════════════════════════

{@divorce_decree}
= @types.audit_info

case_number = :
file_number = :
state_of_divorce = :(2)
county_of_divorce = :
court_name = :

; Divorce Information
{.divorce}
decree_date = date
marriage_date = date
duration_of_marriage_years = ##:(0..)
date_of_separation = date

{@divorce_decree}
; Petitioner
{.petitioner}
first_name = :
middle_name = :
last_name = :
maiden_name = :
date_of_birth = *date
ssn = *:format ssn
address = @address

{@divorce_decree}
; Respondent
{.respondent}
first_name = :
middle_name = :
last_name = :
maiden_name = :
date_of_birth = *date
ssn = *:format ssn
address = @address

{@divorce_decree}
; Children
children_under_18_count = ##:(0..)
{.children[]}
name = :
date_of_birth = *date
custody_awarded_to = (joint, petitioner, respondent)

{@divorce_decree}
; Property Division
property_settlement = ?
alimony_awarded = ?
alimony_recipient = (petitioner, respondent):if alimony_awarded = true
alimony_amount = #$:(0..):if alimony_awarded = true
alimony_frequency = (lump_sum, monthly, weekly):if alimony_awarded = true

{@divorce_decree}
; Decree Issued By
judge_name = :
decree_effective_date = date

; ═══════════════════════════════════════════════════════════════════════════════
; ADOPTION DECREE
; ═══════════════════════════════════════════════════════════════════════════════

{@adoption_decree}
= @types.audit_info

case_number = :
state = :(2)
county = :
court_name = :
decree_date = date

; Adopted Child
{.child}
adopted_first_name = :
adopted_middle_name = :
adopted_last_name = :
birth_first_name = :
birth_middle_name = :
birth_last_name = :
date_of_birth = *date
sex = (female, male)

{@adoption_decree}
; Adoptive Parents
{.adoptive_parents[]}
first_name = :
middle_name = :
last_name = :
relationship = (adoptive_father, adoptive_mother, adoptive_parent)
address = @address

{@adoption_decree}
; Birth Parents (may be sealed)
{.birth_parents[]}
first_name = :
middle_name = :
last_name = :
relationship = (birth_father, birth_mother, birth_parent)
parental_rights_terminated = ?

{@adoption_decree}
; Adoption Type
adoption_type = (agency, independent, international, kinship, stepparent)
agency_name = :if adoption_type = agency
country_of_origin = :(2..3):if adoption_type = international

; Judge
judge_name = :
decree_effective_date = date

; Sealed Records
records_sealed = ?

; ═══════════════════════════════════════════════════════════════════════════════
; NAME CHANGE PETITION
; ═══════════════════════════════════════════════════════════════════════════════

{@name_change_petition}
= @types.audit_info

case_number = :
state = :(2)
county = :
court_name = :
filing_date = date

; Petitioner
{.petitioner}
current_first_name = :
current_middle_name = :
current_last_name = :
proposed_first_name = :
proposed_middle_name = :
proposed_last_name = :
date_of_birth = *date
ssn = *:format ssn
address = @address

{@name_change_petition}
; Reason for Change
reason = :

; Minor Child (if applicable)
{.minor_child}
name_change_for_minor = ?
child_first_name = :if name_change_for_minor = true
child_middle_name = :if name_change_for_minor = true
child_last_name = :if name_change_for_minor = true
child_date_of_birth = *date:if name_change_for_minor = true
{.parents[]}
parent_name = :
consent_given = ?

{@name_change_petition}
; Court Order
order_date = date
judge_name = :
approved = ?
denial_reason = :

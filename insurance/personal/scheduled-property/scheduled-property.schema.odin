; ===================================================================================
; ODIN Scheduled Personal Property (Personal Articles Floater) Schema
; ===================================================================================
; Scheduled personal property (personal articles floater) providing all-risk
; coverage for high-value items including jewelry, fine art, musical instruments,
; cameras, furs, silverware, and collectibles with agreed value.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.personal.scheduled-property"
version = "1.0.0"
title = "Scheduled Personal Property Insurance Schema"
description = "Personal articles floater for valuable personal property items"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Personal Lines Insurance Data Model"
source[0].url = "https://content.naic.org/"

source[1].authority = "Insurance Services Office (ISO)"
source[1].citation = "Personal Inland Marine Coverage Forms"
source[1].url = "https://www.verisk.com/insurance/products/"

source[2].authority = "Texas Department of Insurance"
source[2].citation = "Personal Inland Marine Insurance Guide"
source[2].url = "https://www.tdi.texas.gov/"

source[3].authority = "California Department of Insurance"
source[3].citation = "Valuable Personal Property Insurance Consumer Guide"
source[3].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on standard personal articles floater forms and state regulatory requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial scheduled personal property schema"
changelog[0].rationale = "Personal lines coverage for valuable scheduled items"

; ===================================================================================
; Item Category
; ===================================================================================
; Defines categories for scheduled personal property items.

{@spp_item_category}
category = (
    cameras,                                  ; Camera and photography equipment
    coins,                                    ; Coin collections
    collectibles,                             ; Sports memorabilia, other collectibles
    electronics,                              ; Personal electronics
    fine_arts,                                ; Paintings, sculptures, antiques
    firearms,                                 ; Guns and related equipment
    furs,                                     ; Fur coats and apparel
    golfers_equipment,                        ; Golf clubs and accessories
    jewelry,                                  ; Jewelry, watches, gemstones
    musical_instruments,                      ; Instruments and equipment
    silverware,                               ; Silverware, flatware, hollowware
    stamps,                                   ; Stamp collections
    wine,                                     ; Wine collections
    other                                     ; Other valuable items
)
category_description = :if category = other  ; Description if other selected

; ===================================================================================
; Appraisal Record
; ===================================================================================
; Tracks professional appraisals for scheduled items.

{@spp_appraisal}
; Required fields first
appraised_value = #$:(0..)                   ; Appraised item value
appraisal_date = date                        ; Date of appraisal

; Optional fields
appraiser_address = @address                  ; Appraiser business address
appraiser_certification = :                   ; Professional certifications held
appraiser_license = :                         ; License number if applicable
appraiser_name = :                            ; Name of appraiser
appraiser_organization = :                    ; Professional organization membership
appraisal_id = :                              ; Unique appraisal identifier
appraisal_method = (
    comparable_sales,                         ; Comparison to similar items sold
    cost_approach,                            ; Replacement cost method
    income_approach,                          ; For income-producing items
    market_value                              ; Current market value
)
appraisal_type = (
    damage_assessment,                        ; Post-loss damage appraisal
    initial,                                  ; First appraisal for scheduling
    update                                    ; Updated appraisal
)
condition_rating = (
    excellent,                                ; Mint or near-mint condition
    fair,                                     ; Shows wear, functional
    good,                                     ; Minor wear, well-maintained
    poor                                      ; Significant wear or damage
)
document_reference = :                        ; Reference to appraisal document
expiration_date = date                        ; When appraisal expires
notes = :                                     ; Additional appraisal notes

; ===================================================================================
; Scheduled Item
; ===================================================================================
; Individual item scheduled on the policy with detailed description and valuation.

{@spp_scheduled_item}
; Required fields first
category = @spp_item_category                ; Item category classification
description = :                              ; Detailed item description
item_number = ##:(1..)                       ; Sequential item number
scheduled_amount = #$:(0..)                  ; Scheduled (insured) value

; Optional fields
acquisition_cost = #$:(0..)                   ; Original purchase price
acquisition_date = date                       ; Date item acquired
acquisition_source = :                        ; Where item was acquired
appraisals[] = @spp_appraisal                 ; Appraisal history
artist = :                                    ; Artist name (fine arts)
authenticity_documentation = ?                ; Has authenticity proof
brand = :                                     ; Manufacturer or brand
certificate_number = :                        ; Authentication certificate number
condition = (excellent, fair, good, poor)     ; Current condition
deductible = #$:(0..)                         ; Item-specific deductible
effective_date = date                         ; Coverage effective date
item_id = :                                   ; Unique item identifier
location = @address                           ; Primary storage location
location_description = :                      ; Storage description
make = :                                      ; Make (instruments, equipment)
materials = :                                 ; Materials composition
medium = :                                    ; Medium (fine arts)
model = :                                     ; Model number or name
origin = :                                    ; Country or region of origin
period = :                                    ; Historical period (antiques)
photographs[] = :                             ; Photo document references
provenance = :                                ; Ownership history
serial_number = *:                            ; Serial number
size_dimensions = :                           ; Physical dimensions
title = :                                     ; Title of artwork
year_created = ##                             ; Year item was made/created

; ---------------------------------------------------------------------------
; Jewelry-Specific Fields
; ---------------------------------------------------------------------------
{.jewelry}
carat_weight = #:if category.category = jewelry   ; Total carat weight
center_stone = :if category.category = jewelry    ; Center stone description
certification_lab = (
    AGS,                                      ; American Gem Society
    EGL,                                      ; European Gemological Laboratory
    GIA,                                      ; Gemological Institute of America
    IGI,                                      ; International Gemological Institute
    other
):if category.category = jewelry
clarity = :if category.category = jewelry     ; Diamond clarity grade
color = :if category.category = jewelry       ; Stone color grade
cut = :if category.category = jewelry         ; Cut grade
metal_type = :if category.category = jewelry  ; Gold, platinum, etc.
setting_type = :if category.category = jewelry; Ring setting type

{@spp_scheduled_item}

; ---------------------------------------------------------------------------
; Musical Instrument-Specific Fields
; ---------------------------------------------------------------------------
{.instrument}
case_included = ?:if category.category = musical_instruments
instrument_type = :if category.category = musical_instruments
professional_use = ?:if category.category = musical_instruments

{@spp_scheduled_item}

; ---------------------------------------------------------------------------
; Firearm-Specific Fields
; ---------------------------------------------------------------------------
{.firearm}
action_type = :if category.category = firearms   ; Semi-auto, bolt, etc.
caliber = :if category.category = firearms       ; Caliber or gauge
firearm_type = (
    handgun,
    rifle,
    shotgun,
    other
):if category.category = firearms
storage_type = (
    gun_safe,
    locked_cabinet,
    other,
    trigger_lock
):if category.category = firearms

{@spp_scheduled_item}

; ---------------------------------------------------------------------------
; Wine Collection-Specific Fields
; ---------------------------------------------------------------------------
{.wine}
bottle_count = ##:if category.category = wine    ; Number of bottles
storage_type = (
    climate_controlled,
    offsite_storage,
    wine_cellar,
    wine_refrigerator
):if category.category = wine
vintage_range = :if category.category = wine     ; Range of vintages

{@spp_scheduled_item}

; ===================================================================================
; Coverage Options
; ===================================================================================
; Policy-level coverage options and provisions.

{@spp_coverage_options}
; Required fields first
valuation_method = (
    actual_cash_value,                        ; Depreciated value
    agreed_value,                             ; Pre-agreed amount
    functional_replacement,                   ; Similar function item
    market_value,                             ; Current market price
    replacement_cost                          ; New equivalent cost
)

; Optional fields
automatic_increase = ?                        ; Annual inflation adjustment
automatic_increase_percent = #:(0..25):if automatic_increase = true
blanket_limit = #$:(0..)                      ; Unscheduled items limit
breakage_covered = ?                          ; Accidental breakage included
deductible_type = (flat, none, percentage)    ; Deductible structure
earthquake_covered = ?                        ; Earthquake coverage included
flood_covered = ?                             ; Flood coverage included
mysterious_disappearance = ?                  ; Coverage for unexplained loss
newly_acquired_coverage = ?                   ; Auto-coverage new acquisitions
newly_acquired_days = ##:(30, 60, 90):if newly_acquired_coverage = true
newly_acquired_limit = #$:(0..):if newly_acquired_coverage = true
pairs_sets_clause = (
    agreed_percentage,                        ; Pay agreed % for partial loss
    full_value,                               ; Pay full set value
    proportional                              ; Pay proportional to loss
)
standard_deductible = #$:(0..)                ; Default policy deductible
territory = (
    designated_locations,                     ; Specific locations only
    north_america,                            ; US and Canada
    us_only,                                  ; United States only
    worldwide                                 ; Global coverage
)

; ===================================================================================
; Exclusions
; ===================================================================================
; Standard and optional exclusions for scheduled property coverage.

{@spp_exclusions}
; Standard exclusions (typically always apply)
confiscation = ?true                          ; Government confiscation
electrical_damage = ?                         ; Electrical surge damage
gradual_deterioration = ?true                 ; Wear and tear
inherent_vice = ?true                         ; Item's own defects
insects_vermin = ?true                        ; Pest damage
intentional_damage = ?true                    ; Deliberate damage by insured
mechanical_breakdown = ?                      ; Mechanical failure
mold = ?                                      ; Mold damage
nuclear = ?true                               ; Nuclear hazard
war = ?true                                   ; War and terrorism

; Optional exclusions
earthquake = ?                                ; Earthquake damage excluded
flood = ?                                     ; Flood damage excluded
theft_from_vehicle = ?                        ; Vehicle theft excluded
unattended_vehicle = ?                        ; Left in unattended vehicle

; ===================================================================================
; Endorsements
; ===================================================================================
; Common endorsements for scheduled personal property policies.

{@spp_endorsement}
; Required fields first
effective_date = date                        ; Endorsement effective date
endorsement_number = :                       ; Endorsement identifier

; Optional fields
category_affected = @spp_item_category        ; Category this affects
description = :                               ; Endorsement description
endorsement_type = (
    additional_coverage,                      ; Adds coverage
    coverage_restriction,                     ; Limits coverage
    deductible_change,                        ; Modifies deductible
    item_addition,                            ; Adds scheduled item
    item_deletion,                            ; Removes scheduled item
    limit_change,                             ; Changes limits
    location_change,                          ; Changes covered locations
    other,                                    ; Other modification
    valuation_change                          ; Changes valuation method
)
expiration_date = date                        ; Endorsement expiration
premium_change = #$                           ; Premium impact (+/-)

; ===================================================================================
; Premium Details
; ===================================================================================
; Rating and premium information for the policy.

{@spp_premium}
; Required fields first
total_annual_premium = #$:(0..)              ; Total annual premium

; Optional fields
category_premiums[] = @spp_category_premium   ; Premium by category
minimum_premium = #$:(0..)                    ; Minimum annual premium
policy_fee = #$:(0..)                         ; Policy issuance fee
rate_per_hundred = #                          ; Rate per $100 of coverage
taxes_and_fees = #$:(0..)                     ; State taxes and fees

{@spp_category_premium}
category = @spp_item_category                 ; Item category
item_count = ##                               ; Number of items
premium = #$:(0..)                            ; Premium for category
rate = #                                      ; Category rate
total_value = #$:(0..)                        ; Total scheduled value

; ===================================================================================
; Claim History
; ===================================================================================
; Prior claims on scheduled property items.

{@spp_prior_claim}
; Required fields first
claim_date = date                            ; Date of loss
claim_type = (
    breakage,                                 ; Accidental breakage
    damage,                                   ; Physical damage
    fire,                                     ; Fire damage
    mysterious_disappearance,                 ; Unexplained loss
    other,                                    ; Other cause
    theft,                                    ; Stolen
    water_damage                              ; Water damage
)

; Optional fields
amount_paid = #$:(0..)                        ; Amount paid on claim
claim_id = :                                  ; Claim identifier
claim_status = (closed, denied, open, settled); Claim status
description = :                               ; Loss description
item_reference = :                            ; Reference to scheduled item
recovered = ?                                 ; Item recovered flag
recovery_amount = #$:(0..):if recovered = true

; ===================================================================================
; Named Insured
; ===================================================================================
; Policy owner and additional insureds.

{@spp_named_insured}
; Required fields first
name = @person_name                          ; Insured name

; Optional fields
address = @address                            ; Mailing address
date_of_birth = *date                         ; Date of birth (PII)
email = *@email                               ; Email contact (PII)
insured_type = (
    additional,                               ; Additional named insured
    primary                                   ; Primary named insured
)
phone = *@phone                               ; Phone contact (PII)
relationship = (
    child,                                    ; Child of primary
    domestic_partner,                         ; Domestic partner
    other,                                    ; Other relationship
    parent,                                   ; Parent of primary
    self,                                     ; Primary insured
    spouse                                    ; Spouse of primary
)

; ===================================================================================
; Scheduled Personal Property Policy
; ===================================================================================
; Complete policy composition bringing together all components.

{@scheduled_property_policy}
; Required fields first
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
policy_number = :                            ; Policy number
scheduled_items[] = @spp_scheduled_item      ; Scheduled items (at least one)

; Invariants
:invariant expiration_date > effective_date

; Optional fields
additional_locations[] = @address             ; Additional covered locations
agency = @agency                              ; Issuing agency
billing_address = @address                    ; Billing address
coverage_options = @spp_coverage_options      ; Coverage options
endorsements[] = @spp_endorsement             ; Policy endorsements
exclusions = @spp_exclusions                  ; Applied exclusions
id = :                                        ; Internal policy identifier
named_insureds[] = @spp_named_insured         ; Named insureds
policy_form = (
    PAF,                                      ; Personal Articles Floater
    scheduled_endorsement,                    ; HO endorsement
    standalone                                ; Standalone inland marine
)
policy_status = (
    active,
    cancelled,
    expired,
    pending,
    renewal
)
premium = @spp_premium                        ; Premium information
primary_location = @address                   ; Primary insured location
prior_claims[] = @spp_prior_claim             ; Prior claim history
producer = @producer                          ; Producing agent
renewal_date = date                           ; Next renewal date
state_province = :(2)                         ; Issuing state/province
term_months = ##:(1..36)                      ; Policy term in months
total_scheduled_value = #$:(0..)              ; Total of all scheduled amounts
underwriting = @underwriting_decision         ; Underwriting decision

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
category_count = ##                           ; Number of categories
item_count = ##                               ; Total scheduled items
total_limit = #$:(0..)                        ; Total coverage limit

{@scheduled_property_policy}


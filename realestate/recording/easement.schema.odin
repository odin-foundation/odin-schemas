; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Easement Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property easements and rights-of-way including utility, access, conservation,
; drainage, view, solar, and party wall agreements. Also covers encroachment
; identification, resolution, and recording information.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.recording.easement"
version = "1.0.0"
title = "Real Estate Easement Schema"
description = "Property easements, rights-of-way, and encumbrances"

{$derivation}
source[0].authority = "American Law Institute"
source[0].citation = "Restatement (Third) of Property: Servitudes"
source[0].url = "https://www.ali.org/"

source[1].authority = "Land Trust Alliance"
source[1].citation = "Conservation Easement Standards"
source[1].url = "https://www.landtrustalliance.org/"

source[2].authority = "American Land Title Association"
source[2].citation = "Title Examination Standards"
source[2].url = "https://www.alta.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Easement schema derived from property law and land trust standards"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial easement schema"
changelog[0].rationale = "Comprehensive easement and encumbrance structure"

; ═══════════════════════════════════════════════════════════════════════════════
; EASEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Property easement

{@easement}
; Required fields first
creation_date = !date                                ; Date easement created
easement_type = !(access, aviation, conservation, drainage, flowage, light_air, party_wall, pipeline, public_access, railroad, scenic, solar, transmission, utility, view)
servient_property = !@address                        ; Burdened property address

; Easement identification
easement_id = :                                      ; Unique easement identifier
document_number = :                                  ; Recording document number

; ───────────────────────────────────────────────────────────────────────────────
; Easement Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
creation_method = (condemnation, dedication, express_grant, implication, necessity, prescription, reservation)
appurtenant = ?                                      ; Appurtenant (benefits land) vs. in gross
exclusive = ?                                        ; Exclusive use
affirmative = ?                                      ; Right to use vs. restriction
perpetual = ?                                        ; Perpetual or term
term_years = ##:(0..):if perpetual = false           ; Term in years
gross_type = (commercial, personal):if appurtenant = false

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Servient Estate (Burdened Property)
; ───────────────────────────────────────────────────────────────────────────────
{.servient}
owner_name = :                                       ; Servient owner name
property_address = @address                          ; Property address
legal_description = @re_legal_description            ; Legal description
parcel = @re_parcel_identifiers                      ; Parcel identifiers

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Dominant Estate (Benefited Property) - if appurtenant
; ───────────────────────────────────────────────────────────────────────────────
{.dominant}
owner_name = ::if appurtenant = true                 ; Dominant owner name
property_address = @address:if appurtenant = true    ; Property address
legal_description = @re_legal_description:if appurtenant = true
parcel = @re_parcel_identifiers:if appurtenant = true

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Easement Holder (if in gross)
; ───────────────────────────────────────────────────────────────────────────────
{.holder}
holder_name = ::if appurtenant = false               ; Easement holder
holder_type = (company, government, individual, nonprofit, utility):if appurtenant = false
address = @address:if appurtenant = false            ; Holder address
phone = @phone:if appurtenant = false                ; Phone
assignable = ?:if appurtenant = false                ; Can be assigned

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Easement Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
description = :                                      ; Location description
width_feet = #:(0..)                                 ; Easement width
length_feet = #:(0..)                                ; Easement length
area_sqft = ##:(0..)                                 ; Area in square feet
area_acres = #:(0..)                                 ; Area in acres
metes_bounds = :                                     ; Metes and bounds
survey_reference = :                                 ; Survey reference
exhibit_attached = ?                                 ; Exhibit attached to document

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Rights Granted
; ───────────────────────────────────────────────────────────────────────────────
{.rights}
purpose = :                                          ; Purpose of easement
permitted_uses[] = :                                 ; Permitted uses
prohibited_uses[] = :                                ; Prohibited uses
maintenance_responsibility = (dominant, servient, shared)
improvement_rights = ?                               ; Right to make improvements
improvement_description = ::if improvement_rights = true

{@easement}

; Access easement specifics
{.rights.access}
vehicular = ?:if easement_type = access              ; Vehicle access
pedestrian = ?:if easement_type = access             ; Pedestrian access
emergency = ?:if easement_type = access              ; Emergency access
commercial = ?:if easement_type = access             ; Commercial use
hours_restricted = ?:if easement_type = access       ; Hours restriction
hours_description = ::if hours_restricted = true     ; Hours allowed

{@easement}

; Utility easement specifics
{.rights.utility}
utility_type = (cable, electric, fiber, gas, sewer, telephone, water):if easement_type = utility
above_ground = ?:if easement_type = utility          ; Above ground facilities
below_ground = ?:if easement_type = utility          ; Below ground facilities
depth_feet = #:(0..):if below_ground = true          ; Depth of facilities

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Conservation Easement Specific
; ───────────────────────────────────────────────────────────────────────────────
{.conservation}
holder_type = (government, land_trust):if easement_type = conservation
holder_name = ::if easement_type = conservation      ; Land trust/agency name
irs_qualified = ?:if easement_type = conservation    ; IRC 170(h) qualified
conservation_purpose[] = (agricultural, habitat, historic, open_space, scenic):if easement_type = conservation
baseline_documentation = ?:if easement_type = conservation
baseline_date = date:if baseline_documentation = true
monitoring_required = ?:if easement_type = conservation
monitoring_frequency = ::if monitoring_required = true
amendment_process = ::if easement_type = conservation
extinguishment_conditions = ::if easement_type = conservation
backup_holder = ::if easement_type = conservation

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Consideration
; ───────────────────────────────────────────────────────────────────────────────
{.consideration}
consideration_type = (donation, exchange, nominal, purchase)
amount = #$:(0..):if consideration_type = purchase   ; Purchase price
fair_market_value = #$:(0..)                         ; Fair market value
tax_deduction_claimed = ?:if consideration_type = donation
deduction_amount = #$:(0..):if tax_deduction_claimed = true

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Easement recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county
state = :(2):if recorded = true                      ; Recording state

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Termination
; ───────────────────────────────────────────────────────────────────────────────
{.termination}
terminable = ?                                       ; Can be terminated
termination_conditions[] = :                         ; Termination conditions
expiration_date = date:if perpetual = false          ; Expiration date
release_requirements = :                             ; Requirements for release
merger_terminates = ?                                ; Terminates on merger of estates

{@easement}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, abandoned, expired, released, terminated)
status_date = date                                   ; Status date
termination_reason = ::if status = terminated        ; Reason terminated

; ═══════════════════════════════════════════════════════════════════════════════
; COVENANT/RESTRICTION
; ═══════════════════════════════════════════════════════════════════════════════
; Deed restrictions and covenants

{@restriction}
; Required fields first
creation_date = !date                                ; Date created
property_address = !@address                         ; Property address
restriction_type = !(architectural, building, conservation, historic, land_use, maintenance, setback, subdivision, use)

; Restriction identification
restriction_id = :                                   ; Unique identifier
document_number = :                                  ; Recording document number

; ───────────────────────────────────────────────────────────────────────────────
; Restriction Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
description = :                                      ; Restriction description
affirmative = ?                                      ; Requires action vs. prohibits
perpetual = ?                                        ; Perpetual or term
term_years = ##:(0..):if perpetual = false           ; Term in years
expiration_date = date:if perpetual = false          ; Expiration date
runs_with_land = ?                                   ; Runs with the land

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Enforcement
; ───────────────────────────────────────────────────────────────────────────────
{.enforcement}
enforced_by = :                                      ; Who can enforce
enforcement_type = (any_owner, association, declarant, government)
injunction_available = ?                             ; Injunctive relief available
damages_available = ?                                ; Money damages available
attorney_fees = ?                                    ; Prevailing party attorney fees

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Subdivision/HOA Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.subdivision}
subdivision_name = ::if restriction_type = subdivision
ccr_document = ::if restriction_type = subdivision   ; CC&R document reference
architectural_review = ?:if restriction_type = subdivision
arc_contact = ::if architectural_review = true       ; ARC contact
minimum_sqft = ##:(0..):if restriction_type = subdivision
setback_front = #:(0..):if restriction_type = subdivision
setback_side = #:(0..):if restriction_type = subdivision
setback_rear = #:(0..):if restriction_type = subdivision
height_limit = #:(0..):if restriction_type = subdivision
permitted_uses[] = ::if restriction_type = subdivision
prohibited_uses[] = ::if restriction_type = subdivision

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Historic Restrictions
; ───────────────────────────────────────────────────────────────────────────────
{.historic}
historic_designation = ::if restriction_type = historic
register_listed = ?:if restriction_type = historic   ; National/state register
designation_date = date:if restriction_type = historic
review_authority = ::if restriction_type = historic  ; Review board/commission
permitted_alterations = ::if restriction_type = historic
prohibited_alterations = ::if restriction_type = historic

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Recording
; ───────────────────────────────────────────────────────────────────────────────
{.recording}
recorded = ?                                         ; Restriction recorded
recording_date = date:if recorded = true             ; Recording date
recording_number = ::if recorded = true              ; Document number
book = ::if recorded = true                          ; Book
page = ::if recorded = true                          ; Page
county = ::if recorded = true                        ; Recording county
state = :(2):if recorded = true                      ; Recording state

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Modification/Release
; ───────────────────────────────────────────────────────────────────────────────
{.modification}
modifiable = ?                                       ; Can be modified
modification_requirements = :                        ; Requirements to modify
vote_required = #:(0..100):if modifiable = true      ; Vote percentage required
consent_required[] = ::if modifiable = true          ; Parties whose consent needed

{@restriction}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, abandoned, expired, modified, released)
status_date = date                                   ; Status date

; ═══════════════════════════════════════════════════════════════════════════════
; ENCROACHMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Property encroachment

{@encroachment}
; Required fields first
discovery_date = !date                               ; Date discovered
encroaching_property = !@address                     ; Encroaching property
encroachment_type = !(building, driveway, eave, fence, foundation, landscaping, other, roof, utility, wall)
impacted_property = !@address                        ; Impacted property

; Encroachment identification
encroachment_id = :                                  ; Unique identifier

; ───────────────────────────────────────────────────────────────────────────────
; Encroachment Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
description = :                                      ; Description of encroachment
dimension_width = #:(0..)                            ; Width in feet
dimension_length = #:(0..)                           ; Length in feet
dimension_height = #:(0..)                           ; Height in feet
area_sqft = #:(0..)                                  ; Area in square feet
structure_type = :                                   ; Type of structure
date_constructed = date                              ; Approximate construction date
intentional = ?                                      ; Intentional vs. mistake
visible = ?                                          ; Visible from survey
discovered_by = (appraisal, neighbor, owner, survey, title_search)

{@encroachment}

; ───────────────────────────────────────────────────────────────────────────────
; Survey Information
; ───────────────────────────────────────────────────────────────────────────────
{.survey}
survey_date = date                                   ; Survey date
surveyor_name = :                                    ; Surveyor name
surveyor_license = :                                 ; Surveyor license
survey_reference = :                                 ; Survey document reference

{@encroachment}

; ───────────────────────────────────────────────────────────────────────────────
; Resolution
; ───────────────────────────────────────────────────────────────────────────────
{.resolution}
resolution_type = (boundary_adjustment, easement_granted, encroachment_agreement, insurance_exception, litigation, removal, unresolved)
resolution_date = date:if resolution_type != unresolved
resolution_document = ::if resolution_type != unresolved
removal_required = ?:if resolution_type = removal    ; Removal required
removal_deadline = date:if removal_required = true   ; Removal deadline
removal_cost = #$:(0..):if removal_required = true   ; Estimated removal cost
responsible_party = ::if removal_required = true     ; Who pays for removal

{@encroachment}

; Encroachment agreement
{.resolution.agreement}
agreement_date = date:if resolution_type = encroachment_agreement
parties[] = ::if resolution_type = encroachment_agreement
term = ::if resolution_type = encroachment_agreement ; Term/duration
payment = #$:(0..):if resolution_type = encroachment_agreement
indemnification = ?:if resolution_type = encroachment_agreement
runs_with_land = ?:if resolution_type = encroachment_agreement
recording_reference = ::if resolution_type = encroachment_agreement

{@encroachment}

; ───────────────────────────────────────────────────────────────────────────────
; Title Insurance
; ───────────────────────────────────────────────────────────────────────────────
{.title_insurance}
affects_title = ?                                    ; Affects title insurance
exception_raised = ?                                 ; Exception on commitment
exception_waived = ?:if exception_raised = true      ; Exception waived
waiver_conditions = ::if exception_waived = true     ; Conditions for waiver
affirmative_coverage = ?                             ; Affirmative coverage available
endorsement_required = ::if affirmative_coverage = true

{@encroachment}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, in_litigation, resolved, unresolved)
status_date = date                                   ; Status date


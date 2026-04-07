; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Real Estate Sale/Listing Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Property listings and sale transactions including listing agreements,
; property marketing, showing management, offer tracking, and sale completion.
; Covers agent commissions, MLS integration, and listing status workflows.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as common
@import "../types.schema.odin" as re

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.realestate.transaction.sale"
version = "1.0.0"
title = "Real Estate Sale/Listing Schema"
description = "Property listing and sale transaction management"

{$derivation}
source[0].authority = "National Association of Realtors"
source[0].citation = "MLS policies and listing standards"
source[0].url = "https://www.nar.realtor/"

source[1].authority = "RESO"
source[1].citation = "Real Estate Standards Organization Data Dictionary"
source[1].url = "https://www.reso.org/data-dictionary/"

source[2].authority = "State Real Estate Commissions"
source[2].citation = "Listing agreement and agency disclosure requirements"
source[2].url = "https://web.archive.org/web/20250101041308/https://www.arello.org/"

methodology = "industry_practice"
proprietary_sources_consulted = ?false
notes = "Sale/listing schema derived from MLS standards and real estate practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial sale/listing schema"
changelog[0].rationale = "Comprehensive listing management structure"

; ═══════════════════════════════════════════════════════════════════════════════
; LISTING AGREEMENT
; ═══════════════════════════════════════════════════════════════════════════════
; Agreement between seller and listing broker

{@listing_agreement}
; Required fields first
agreement_type = !(exclusive_agency, exclusive_right_to_sell, net_listing, open)
commencement_date = !date                         ; Agreement start date
expiration_date = !date                           ; Agreement expiration
list_price = !#$:(0..)                            ; Initial list price
property_address = !@address                      ; Property address

:invariant expiration_date > commencement_date    ; End must be after start

; Agreement identification
agreement_id = :                                  ; Unique agreement identifier

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
sellers[] = @re_party                             ; Seller(s)
listing_agent = @re_agent                         ; Listing agent
listing_broker = @re_company                      ; Listing brokerage
co_listing_agent = @re_agent                      ; Co-listing agent

{@listing_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Commission
; ───────────────────────────────────────────────────────────────────────────────
{.commission}
total_rate = #:(0..100)                           ; Total commission rate
listing_side_rate = #:(0..100)                    ; Listing broker rate
buyer_side_rate = #:(0..100)                      ; Buyer broker rate
variable_rate = ?                                 ; Variable rate structure
variable_rate_schedule = ::if variable_rate = true
flat_fee = #$:(0..)                               ; Flat fee (if applicable)
minimum_commission = #$:(0..)                     ; Minimum commission

{@listing_agreement}

; Referral
{.commission.referral}
referral_due = ?                                  ; Referral fee owed
referral_to = ::if referral_due = true            ; Referral recipient
referral_rate = #:(0..100):if referral_due = true ; Referral rate

{@listing_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Marketing Authorization
; ───────────────────────────────────────────────────────────────────────────────
{.marketing}
mls_authorized = ?                                ; MLS listing authorized
internet_authorized = ?                           ; Internet advertising
sign_authorized = ?                               ; Yard sign authorized
lockbox_authorized = ?                            ; Lockbox authorized
open_house_authorized = ?                         ; Open houses authorized
photography_authorized = ?                        ; Professional photos
video_authorized = ?                              ; Video/virtual tour
drone_authorized = ?                              ; Drone photography
print_authorized = ?                              ; Print advertising

{@listing_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Seller Disclosures
; ───────────────────────────────────────────────────────────────────────────────
{.disclosures}
seller_disclosure_provided = ?                    ; Seller disclosure form
disclosure_date = date:if seller_disclosure_provided = true
lead_paint_disclosure = ?                         ; Lead paint (pre-1978)
hoa_disclosure = ?                                ; HOA disclosure
additional_disclosures[] = :                      ; Other required disclosures

{@listing_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Showing Instructions
; ───────────────────────────────────────────────────────────────────────────────
{.showing}
appointment_required = ?                          ; Appointment needed
notice_hours = ##:(0..)                           ; Hours notice required
lockbox_code = *:                                 ; Lockbox code
access_instructions = :                           ; Access instructions
occupied = ?                                      ; Property is occupied
pet_on_premises = ?                               ; Pet at property
alarm_code = *:                                   ; Alarm code
showing_contact = :                               ; Who to contact
showing_phone = *@phone                           ; Contact phone

{@listing_agreement}

; ───────────────────────────────────────────────────────────────────────────────
; Agreement Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, closed, expired, pending, withdrawn)
status_date = date                                ; Status change date
cancellation_reason = ::if status = cancelled     ; Cancellation reason
cancellation_fee = #$:(0..):if status = cancelled ; Cancellation fee

; ═══════════════════════════════════════════════════════════════════════════════
; PROPERTY LISTING
; ═══════════════════════════════════════════════════════════════════════════════
; MLS listing information

{@property_listing}
; Required fields first
list_date = !date                                 ; Date listed
list_price = !#$:(0..)                            ; Current list price
property_address = !@address                      ; Property address

; Listing identification
mls_number = :                                    ; MLS listing number
listing_id = :                                    ; Internal listing ID

; Agreement reference
listing_agreement_ref = @listing_agreement        ; Reference to listing agreement

; Property reference
property_ref = :                                  ; Reference to property schema

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Listing Details
; ───────────────────────────────────────────────────────────────────────────────
{.listing}
property_type = (commercial, condominium, coop, land, manufactured, multi_family, single_family, townhouse)
property_subtype = :                              ; Detailed type
listing_type = (auction, exclusive, standard)     ; Type of listing
transaction_type = (for_sale, for_sale_or_lease)  ; Transaction type

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Pricing
; ───────────────────────────────────────────────────────────────────────────────
{.pricing}
original_list_price = #$:(0..)                    ; Original list price
current_list_price = #$:(0..)                     ; Current list price
price_per_sqft = #$:(0..)                         ; Price per square foot
price_per_acre = #$:(0..)                         ; Price per acre (land)
price_change_count = ##:(0..)                     ; Number of price changes
last_price_change = date                          ; Last price change date
price_reduced = ?                                 ; Price has been reduced

{@property_listing}

; Price history
{.pricing.history[]}
effective_date = date                             ; Date of price
price = #$:(0..)                                  ; Price at this date
change_type = (increase, initial, reduction)      ; Type of change

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Property Description
; ───────────────────────────────────────────────────────────────────────────────
{.description}
public_remarks = :                                ; Public marketing description
private_remarks = :                               ; Agent-only remarks
directions = :                                    ; Directions to property
showing_instructions = :                          ; Showing instructions
virtual_tour_url = :                              ; Virtual tour link
video_url = :                                     ; Video link

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Photos
; ───────────────────────────────────────────────────────────────────────────────
{.photos[]}
photo_order = ##:(1..)                            ; Display order
photo_url = :                                     ; Photo URL
photo_description = :                             ; Photo caption
primary = ?                                       ; Primary listing photo

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Features (for MLS)
; ───────────────────────────────────────────────────────────────────────────────
{.features}
bedrooms = ##:(0..)                               ; Bedroom count
bathrooms_full = ##:(0..)                         ; Full bath count
bathrooms_half = ##:(0..)                         ; Half bath count
sqft_living = ##:(0..)                            ; Living area sqft
sqft_total = ##:(0..)                             ; Total sqft
lot_sqft = ##:(0..)                               ; Lot size sqft
lot_acres = #:(0..)                               ; Lot size acres
year_built = ##:(1600..2100)                      ; Year built
stories = #:(0..)                                 ; Number of stories
garage_spaces = ##:(0..)                          ; Garage capacity
pool = ?                                          ; Has pool
waterfront = ?                                    ; Waterfront property
hoa = ?                                           ; Subject to HOA
hoa_fee = #$:(0..):if hoa = true                  ; HOA fee
hoa_frequency = (annual, monthly, quarterly):if hoa = true

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Compensation
; ───────────────────────────────────────────────────────────────────────────────
{.compensation}
buyer_agent_compensation = :                      ; Compensation offered
compensation_type = (dollar, percent)             ; Compensation type
compensation_amount = #$:(0..):if compensation_type = dollar
compensation_percent = #:(0..100):if compensation_type = percent
bonus_offered = ?                                 ; Bonus for quick sale
bonus_amount = #$:(0..):if bonus_offered = true
bonus_conditions = ::if bonus_offered = true      ; Bonus conditions

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Listing Status
; ───────────────────────────────────────────────────────────────────────────────
standard_status = !(active, active_under_contract, cancelled, closed, coming_soon, expired, hold, pending, withdrawn)
status_date = date                                ; Status change date
days_on_market = ##:(0..)                         ; Current DOM
cumulative_dom = ##:(0..)                         ; Cumulative DOM

{@property_listing}

; Under contract details
{.under_contract}
contract_date = date:if standard_status = active_under_contract
contingent = ?:if standard_status = active_under_contract
contingency_type = (appraisal, financing, home_sale, inspection):if contingent = true
backup_offers_accepted = ?:if standard_status = active_under_contract
expected_closing = date:if standard_status = active_under_contract

{@property_listing}

; ───────────────────────────────────────────────────────────────────────────────
; Closed Sale Information
; ───────────────────────────────────────────────────────────────────────────────
{.closed}
sold_date = date:if standard_status = closed      ; Closing date
sold_price = #$:(0..):if standard_status = closed ; Sold price
sold_price_per_sqft = #$:(0..):if standard_status = closed
buyer_agent = @re_agent:if standard_status = closed
buyer_broker = @re_company:if standard_status = closed
financing_type = (cash, conventional, fha, other, seller_finance, usda, va):if standard_status = closed
concessions = #$:(0..):if standard_status = closed  ; Total concessions

{@property_listing}

; ═══════════════════════════════════════════════════════════════════════════════
; SHOWING
; ═══════════════════════════════════════════════════════════════════════════════
; Individual property showing

{@showing}
; Required fields first
listing_ref = !@property_listing                  ; Reference to listing
showing_date = !date                              ; Showing date
showing_time = !time                              ; Showing time

; Showing identification
showing_id = :                                    ; Unique showing identifier

; ───────────────────────────────────────────────────────────────────────────────
; Showing Details
; ───────────────────────────────────────────────────────────────────────────────
showing_agent = @re_agent                         ; Agent conducting showing
showing_type = (agent, broker_open, open_house, private, virtual)
duration_minutes = ##:(0..)                       ; Scheduled duration
end_time = time                                   ; End time

; ───────────────────────────────────────────────────────────────────────────────
; Buyer Information
; ───────────────────────────────────────────────────────────────────────────────
{.buyer}
buyer_name = :                                    ; Buyer name
buyer_phone = *@phone                             ; Buyer phone
buyer_email = *@email                             ; Buyer email
buyer_agent = @re_agent                           ; Buyer's agent
buyer_pre_approved = ?                            ; Buyer is pre-approved
pre_approval_amount = #$:(0..):if buyer_pre_approved = true

{@showing}

; ───────────────────────────────────────────────────────────────────────────────
; Feedback
; ───────────────────────────────────────────────────────────────────────────────
{.feedback}
feedback_requested = ?                            ; Feedback requested
feedback_received = ?                             ; Feedback provided
overall_impression = (excellent, fair, good, not_interested, poor)
price_opinion = (overpriced, priced_right, underpriced)
condition_opinion = (excellent, fair, good, needs_work, poor)
interest_level = (high, low, medium, will_make_offer)
comments = :                                      ; Feedback comments

{@showing}

; ───────────────────────────────────────────────────────────────────────────────
; Showing Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, confirmed, no_show, pending, rescheduled)
status_date = date                                ; Status change date
cancellation_reason = ::if status = cancelled     ; Cancellation reason

; ═══════════════════════════════════════════════════════════════════════════════
; OPEN HOUSE
; ═══════════════════════════════════════════════════════════════════════════════
; Open house event

{@open_house}
; Required fields first
listing_ref = !@property_listing                  ; Reference to listing
open_house_date = !date                           ; Open house date
start_time = !time                                ; Start time
end_time = !time                                  ; End time

; Open house identification
open_house_id = :                                 ; Unique open house identifier

; ───────────────────────────────────────────────────────────────────────────────
; Event Details
; ───────────────────────────────────────────────────────────────────────────────
open_house_type = !(broker_open, public, twilight, virtual)
hosting_agent = @re_agent                         ; Agent hosting
refreshments = ?                                  ; Refreshments provided
description = :                                   ; Event description

; ───────────────────────────────────────────────────────────────────────────────
; Marketing
; ───────────────────────────────────────────────────────────────────────────────
{.marketing}
mls_advertised = ?                                ; Listed in MLS
syndication = ?                                   ; Syndicated to portals
social_media = ?                                  ; Social media promotion
print_advertising = ?                             ; Print advertising
directional_signs = ?                             ; Directional signs

{@open_house}

; ───────────────────────────────────────────────────────────────────────────────
; Attendance
; ───────────────────────────────────────────────────────────────────────────────
{.attendance}
visitor_count = ##:(0..)                          ; Total visitors
groups = ##:(0..)                                 ; Number of groups
leads_captured = ##:(0..)                         ; Lead cards collected

{@open_house}

; Visitors
{.attendance.visitors[]}
visitor_name = :                                  ; Visitor name
visitor_phone = *@phone                           ; Phone
visitor_email = *@email                           ; Email
working_with_agent = ?                            ; Has an agent
agent_name = ::if working_with_agent = true       ; Agent name
buyer_type = (first_time, investor, move_up, relocation)
interest_level = (high, low, medium)
follow_up_needed = ?                              ; Needs follow-up
notes = :                                         ; Notes about visitor

{@open_house}

; ───────────────────────────────────────────────────────────────────────────────
; Open House Status
; ───────────────────────────────────────────────────────────────────────────────
status = (cancelled, completed, scheduled)
status_date = date                                ; Status change date


; ===================================================================================
; ODIN Media Insurance Schema
; ===================================================================================
; Media and communications insurance for publishers, broadcasters, digital media,
; advertising agencies, and content creators covering media E&O, defamation,
; privacy, intellectual property, and publishers/broadcasters liability.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.entertainment.media"
version = "1.0.0"
title = "Media Insurance Schema"
description = "E&O and liability coverage for media and communications companies"

{$derivation}
source[0].authority = "National Association of Insurance Commissioners (NAIC)"
source[0].citation = "Professional Liability - Media E&O"
source[0].url = "https://content.naic.org/"

source[1].authority = "Media Law Resource Center"
source[1].citation = "Media Liability Law and Insurance"
source[1].url = "https://www.medialaw.org/"

source[2].authority = "International News Media Association"
source[2].citation = "Media Industry Insurance Standards"
source[2].url = "https://www.inma.org/"

source[3].authority = "Association of National Advertisers"
source[3].citation = "Advertising Industry Risk Management"
source[3].url = "https://www.ana.net/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Schema based on media liability law and industry insurance practices"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial media insurance schema"
changelog[0].rationale = "Commercial entertainment coverage for media companies"

; ===================================================================================
; Media Company Classification
; ===================================================================================

{@media_type}
company_type = !(
    advertising_agency,                       ; Ad agency
    book_publisher,                           ; Book publishing
    broadcaster_radio,                        ; Radio broadcaster
    broadcaster_tv,                           ; TV broadcaster
    content_creator,                          ; Content creator
    digital_media,                            ; Digital/online media
    event_promoter,                           ; Event promotion
    gaming_esports,                           ; Gaming/esports
    influencer,                               ; Social media influencer
    magazine_publisher,                       ; Magazine publishing
    marketing_agency,                         ; Marketing firm
    news_organization,                        ; News media
    newspaper_publisher,                      ; Newspaper
    podcast,                                  ; Podcasting
    pr_agency,                                ; PR firm
    production_company,                       ; Media production
    streaming_platform,                       ; Streaming service
    web_publisher                             ; Web publishing
)

; Content type
content = (
    advertising,                              ; Advertising content
    educational,                              ; Educational content
    entertainment,                            ; Entertainment
    financial,                                ; Financial news/info
    general_interest,                         ; General interest
    health_medical,                           ; Health/medical
    news_journalism,                          ; News/journalism
    political,                                ; Political content
    religious,                                ; Religious content
    sports,                                   ; Sports content
    technical                                 ; Technical/trade
)

; Distribution
distribution = (
    broadcast,                                ; Broadcast
    digital,                                  ; Digital/online
    print,                                    ; Print
    social_media,                             ; Social platforms
    streaming                                 ; Streaming
)

; ===================================================================================
; Media Company Details
; ===================================================================================

{@media_company}
; Required fields first
annual_revenue = !#$:(0..)                    ; Annual revenue
company_name = !:                             ; Company name
media_type = !@media_type                     ; Company classification

; Optional fields
address = @address                            ; Business address
audience_size = ##                            ; Audience reach
circulation = ##                              ; Circulation/distribution
content_review = ?                            ; Content review process
dba = :                                       ; DBA name
editorial_policy = ?                          ; Editorial guidelines
email = *@email                               ; Contact email
employee_count = ##                           ; Employee count
fein = *:                                     ; Tax ID
freelancers = ##                              ; Freelancer count
international = ?                             ; International content
legal_review = ?                              ; Legal review process
media_id = :                                  ; Internal identifier
niche_specialty = :                           ; Specialty focus
phone = *@phone                               ; Contact phone
platform[] = :                                ; Distribution platforms
social_media_followers = ##                   ; Social following
ugc = ?                                       ; User-generated content
website = :                                   ; Website URL
years_in_business = ##                        ; Years operating

; ===================================================================================
; Media E&O Coverage
; ===================================================================================

{@media_eo}
; Required fields first
each_claim = !#$:(0..)                        ; Per claim limit
aggregate = !#$:(0..)                         ; Aggregate limit

; Optional fields
consent_to_settle = ?                         ; Hammer clause
deductible = #$:(0..)                         ; Deductible
defense_costs = (included, supplementary)     ; Defense inside/outside
extended_reporting = ?                        ; Tail coverage
prior_acts = ?                                ; Prior acts covered
prior_acts_date = date:if prior_acts = true   ; Retroactive date

; ---------------------------------------------------------------------------
; Covered Wrongful Acts
; ---------------------------------------------------------------------------
{.wrongful_acts}
breach_of_contract = ?                        ; Contract breach
confidentiality = ?                           ; Breach of confidence
copyright = ?                                 ; Copyright infringement
defamation = ?                                ; Libel/slander
emotional_distress = ?                        ; Emotional distress
false_advertising = ?                         ; False advertising
idea_submission = ?                           ; Idea theft
invasion_of_privacy = ?                       ; Privacy invasion
misappropriation = ?                          ; Name/likeness
negligence = ?                                ; Professional negligence
plagiarism = ?                                ; Plagiarism
right_of_publicity = ?                        ; Publicity rights
trade_libel = ?                               ; Trade libel
trademark = ?                                 ; Trademark

{@media_eo}

; ===================================================================================
; Publishers Liability
; ===================================================================================

{@media_publishers}
included = ?                                  ; Publishers liability

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
deductible = #$:(0..):if included = true      ; Deductible
each_claim = #$:(0..):if included = true      ; Per claim limit

; Covered activities
advertising = ?:if included = true            ; Advertising content
book_publishing = ?:if included = true        ; Book publishing
digital_content = ?:if included = true        ; Digital publishing
magazine = ?:if included = true               ; Magazine publishing
newsletter = ?:if included = true             ; Newsletter
newspaper = ?:if included = true              ; Newspaper publishing
web_content = ?:if included = true            ; Web publishing

; ===================================================================================
; Broadcasters Liability
; ===================================================================================

{@media_broadcasters}
included = ?                                  ; Broadcasters liability

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
deductible = #$:(0..):if included = true      ; Deductible
each_claim = #$:(0..):if included = true      ; Per claim limit

; Covered activities
cable = ?:if included = true                  ; Cable broadcast
podcast = ?:if included = true                ; Podcasting
radio = ?:if included = true                  ; Radio broadcast
streaming = ?:if included = true              ; Streaming content
television = ?:if included = true             ; TV broadcast
webcast = ?:if included = true                ; Webcasting

; ===================================================================================
; Cyber Liability
; ===================================================================================

{@media_cyber}
included = ?                                  ; Cyber coverage

; First-party coverage
aggregate = #$:(0..):if included = true       ; Aggregate limit
business_interruption = ?:if included = true  ; BI coverage
data_breach = ?:if included = true            ; Data breach response
deductible = #$:(0..):if included = true      ; Deductible
each_claim = #$:(0..):if included = true      ; Per claim limit
extortion = ?:if included = true              ; Cyber extortion
forensics = ?:if included = true              ; Forensic costs
notification = ?:if included = true           ; Notification costs
restoration = ?:if included = true            ; Data restoration

; Third-party coverage
network_security = ?:if included = true       ; Network security
privacy_liability = ?:if included = true      ; Privacy liability
regulatory_defense = ?:if included = true     ; Regulatory defense

; ===================================================================================
; Intellectual Property Coverage
; ===================================================================================

{@media_ip}
included = ?                                  ; IP coverage

; Coverage terms
aggregate = #$:(0..):if included = true       ; Aggregate limit
deductible = #$:(0..):if included = true      ; Deductible
defense = ?:if included = true                ; IP defense costs
each_claim = #$:(0..):if included = true      ; Per claim limit
infringement_defense = ?:if included = true   ; Defense against claims
infringement_pursuit = ?:if included = true   ; Pursuit of infringers

; Covered IP
copyright = ?:if included = true              ; Copyright
patent = ?:if included = true                 ; Patent
trade_dress = ?:if included = true            ; Trade dress
trade_secret = ?:if included = true           ; Trade secret
trademark = ?:if included = true              ; Trademark

; ===================================================================================
; General Liability
; ===================================================================================

{@media_gl}
; Required fields first
each_occurrence = !#$:(0..)                   ; Per occurrence limit
general_aggregate = !#$:(0..)                 ; Aggregate limit

; Optional fields
damage_to_premises = #$:(0..)                 ; Fire legal
deductible = #$:(0..)                         ; Liability deductible
employers_liability = ?                       ; EL coverage
el_limit = #$:(0..):if employers_liability = true
excess_umbrella = ?                           ; Excess/umbrella
excess_limit = #$:(0..):if excess_umbrella = true
medical_payments = #$:(0..)                   ; Med pay limit
personal_advertising_injury = #$:(0..)        ; Personal/advertising
products_completed = ?                        ; Products/completed ops

; ===================================================================================
; Premium Details
; ===================================================================================

{@media_premium}
; Required fields first
total_premium = !#$:(0..)                     ; Total premium

; Optional fields
broadcasters_premium = #$:(0..)               ; Broadcasters premium
cyber_premium = #$:(0..)                      ; Cyber premium
eo_premium = #$:(0..)                         ; E&O premium
gl_premium = #$:(0..)                         ; GL premium
ip_premium = #$:(0..)                         ; IP premium
minimum_premium = #$:(0..)                    ; Minimum premium
policy_fee = #$:(0..)                         ; Policy fee
publishers_premium = #$:(0..)                 ; Publishers premium
taxes_and_fees = #$:(0..)                     ; Taxes/fees

; ---------------------------------------------------------------------------
; Rating Factors
; ---------------------------------------------------------------------------
{.rating}
claims_experience = #                         ; Experience factor
content_factor = #                            ; Content type
distribution_factor = #                       ; Distribution method
revenue_factor = #                            ; Revenue tier
type_factor = #                               ; Media type
ugc_factor = #                                ; User content factor

{@media_premium}

; ===================================================================================
; Claims
; ===================================================================================

{@media_claim}
; Required fields first
claim_date = !date                            ; Claim date
claim_type = !(
    breach_of_contract,                       ; Contract breach
    copyright,                                ; Copyright claim
    cyber_breach,                             ; Data breach
    defamation,                               ; Libel/slander
    false_advertising,                        ; False advertising
    invasion_of_privacy,                      ; Privacy claim
    negligence,                               ; Professional negligence
    patent,                                   ; Patent claim
    plagiarism,                               ; Plagiarism
    right_of_publicity,                       ; Publicity rights
    trade_secret,                             ; Trade secret
    trademark,                                ; Trademark claim
    other                                     ; Other
)

; Optional fields
amount_claimed = #$:(0..)                     ; Amount claimed
amount_paid = #$:(0..)                        ; Amount paid
claim_id = :                                  ; Claim ID
claim_status = (
    closed,
    denied,
    litigation,
    open,
    paid,
    reserved,
    settled
)
claimant_name = :                             ; Claimant name
content_at_issue = :                          ; Content involved
deductible_applied = #$:(0..)                 ; Deductible
defense_costs = #$:(0..)                      ; Defense costs
description = :                               ; Description
jurisdiction = :                              ; Jurisdiction
litigation = ?                                ; In litigation
platform = :                                  ; Platform involved
publication_date = date                       ; Publication date
reserve = #$:(0..)                            ; Reserve amount

; ===================================================================================
; Media Insurance Policy
; ===================================================================================

{@media_policy}
; Required fields first
company = !@media_company                     ; Insured company
effective_date = !date                        ; Policy effective date
eo = !@media_eo                               ; E&O coverage
expiration_date = !date                       ; Policy expiration date
policy_number = !:                            ; Policy number

; Invariants
:invariant expiration_date > effective_date

; Optional fields
agency = @agency                              ; Issuing agency
broadcasters = @media_broadcasters            ; Broadcasters coverage
claims[] = @media_claim                       ; Claims history
cyber = @media_cyber                          ; Cyber coverage
endorsements[] = :                            ; Policy endorsements
gl = @media_gl                                ; General liability
id = :                                        ; Internal identifier
ip = @media_ip                                ; IP coverage
policy_form = (
    manuscript,                               ; Manuscript form
    package,                                  ; Package policy
    standalone                                ; Standalone E&O
)
policy_status = (
    active,
    cancelled,
    expired,
    non_renewed,
    pending
)
premium = @media_premium                      ; Premium details
producer = @producer                          ; Agent
publishers = @media_publishers                ; Publishers coverage
underwriting = @underwriting_decision         ; Underwriting

; ---------------------------------------------------------------------------
; Policy Summary
; ---------------------------------------------------------------------------
{.summary}
company_name = :                              ; Company name
eo_limit = #$:(0..)                           ; E&O limit
media_type = :                                ; Media type
revenue = #$:(0..)                            ; Annual revenue

{@media_policy}


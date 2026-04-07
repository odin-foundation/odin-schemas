; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Logistics Customs and Trade Compliance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Customs entry documentation, HTS classification, valuation, country of origin,
; PGA compliance, and bonding for US imports and exports.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.logistics.customs"
version = "1.0.0"
title = "Logistics Customs and Trade Compliance Schema"
description = "Customs entry, HTS classification, valuation, origin, and compliance"

{$derivation}
source[0].authority = "CBP"
source[0].citation = "19 CFR - Customs Duties"
source[0].url = "https://www.ecfr.gov/current/title-19"

source[1].authority = "CBP"
source[1].citation = "CBP Form 7501 - Entry Summary"
source[1].url = "https://www.cbp.gov/trade/automated"

source[2].authority = "USITC"
source[2].citation = "Harmonized Tariff Schedule of the United States (HTSUS)"
source[2].url = "https://hts.usitc.gov/"

source[3].authority = "USMCA"
source[3].citation = "United States-Mexico-Canada Agreement (USMCA)"
source[3].url = "https://ustr.gov/trade-agreements/free-trade-agreements/united-states-mexico-canada-agreement"

source[4].authority = "CBP"
source[4].citation = "19 USC Chapter 4 - Tariff Act of 1930"
source[4].url = "https://www.govinfo.gov/content/pkg/USCODE-2011-title19/html/USCODE-2011-title19-chap4.htm"

source[5].authority = "FDA"
source[5].citation = "21 CFR - Food and Drugs"
source[5].url = "https://www.accessdata.fda.gov/scripts/cdrh/cfdocs/cfcfr/cfrsearch.cfm"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial customs and trade compliance schema"
changelog[0].rationale = "CBP entry, HTS, valuation, origin, PGA compliance structures"

; ═══════════════════════════════════════════════════════════════════════════════
; HTS CLASSIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@hts_classification}
; Required fields first
hts_number = !:(6..10)                               ; HTS number (6-10 digits)

; Optional fields
description = :                                      ; HTS description
unit_of_quantity = :                                 ; First unit of quantity
second_unit_of_quantity = :                          ; Second unit of quantity

; Duty rates
{.duty}
general_rate = :                                     ; General/Column 1 rate
special_rate = :                                     ; Special program rate
column_2_rate = :                                    ; Column 2 rate
unit = :                                             ; Duty unit (%, ad valorem, specific)

{@hts_classification}

; Tariff preference programs
preference_program = (
    AGOA,                                            ; African Growth and Opportunity Act
    ATPA,                                            ; Andean Trade Preference Act
    CAFTA_DR,                                        ; Central America-Dominican Republic FTA
    CBERA,                                           ; Caribbean Basin Economic Recovery Act
    CBI,                                             ; Caribbean Basin Initiative
    CBTPA,                                           ; Caribbean Basin Trade Partnership Act
    CFTA,                                            ; Canada FTA (legacy)
    GSP,                                             ; Generalized System of Preferences
    NAFTA,                                           ; NAFTA (legacy, pre-USMCA)
    USMCA                                            ; United States-Mexico-Canada Agreement
)

; Rulings
binding_ruling_number = :                            ; CBP binding ruling number
binding_ruling_date = date                           ; Ruling date
ruling_applicability = :                             ; Applicability notes

; Restrictions
quota = ?                                            ; Subject to quota
quota_category = :                                   ; Quota category
antidumping = ?                                      ; Subject to antidumping duty
countervailing = ?                                   ; Subject to countervailing duty
section_301 = ?                                      ; Subject to Section 301 duties

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMS VALUATION
; ═══════════════════════════════════════════════════════════════════════════════

{@customs_valuation}
; Required fields first
method = (
    computed_value,
    deductive_value,
    fallback,
    identical_merchandise,
    similar_merchandise,
    transaction_value
)
declared_value = !#$:(0..)                           ; Declared customs value
currency = :(3) "USD"                                ; Currency code

; Transaction value components
{.transaction_value}
price_paid = #$:(0..)                                ; Price paid or payable
assists = #$                                         ; Assists value
royalties = #$                                       ; Royalties and license fees
proceeds = #$                                        ; Proceeds from resale
packing_costs = #$                                   ; Packing costs
selling_commissions = #$                             ; Selling commissions
inland_freight = #$                                  ; Inland freight to export
export_charges = #$                                  ; Loading and export charges

{@customs_valuation}

; Deductions
{.deductions}
international_freight = #$                           ; International freight
international_insurance = #$                         ; International insurance
unloading_charges = #$                               ; Unloading charges
construction_charges = #$                            ; Construction/assembly charges post-import

{@customs_valuation}

; Related party transaction
related_party = ?                                    ; Buyer and seller related
relationship_affected_price = ?:if related_party = true
circumstances_of_sale_test = ?:if related_party = true

; Adjustments
dutiable_value = #$:(0..)                            ; Final dutiable value
value_additions = #$                                 ; Total additions
value_deductions = #$                                ; Total deductions

:invariant dutiable_value >= 0

; ═══════════════════════════════════════════════════════════════════════════════
; ORIGIN CERTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════

{@origin_certification}
; Required fields first
country_of_origin = !:(2)                            ; ISO country code
origin_criterion = (
    A,                                               ; Wholly obtained
    B,                                               ; Produced entirely
    C,                                               ; Tariff shift
    D,                                               ; Regional value content
    E,                                               ; Assembly
    F                                                ; Other
)

; Optional fields
certificate_type = (
    commercial_invoice_declaration,
    usmca_certification,
    form_a_gsp,
    other
)
certificate_number = :                               ; Certificate number
certificate_date = date                              ; Certificate date
certified_by = :                                     ; Name of certifier
certifier_title = :                                  ; Certifier title

; USMCA/NAFTA specific
{.usmca}
producer = ?                                         ; Producer same as exporter
producer_name = :                                    ; Producer name if different
producer_address = @types.address                    ; Producer address
blanket_period_start = date                          ; Blanket period start
blanket_period_end = date                            ; Blanket period end
regional_value_content_method = (build_down, build_up, net_cost)
rvn_percentage = #:(0..100)                          ; RVC percentage

{@origin_certification}

; Preferential treatment
preference_claimed = ?                               ; Preferential duty claimed
preference_program = (
    AGOA, ATPA, CAFTA_DR, CBERA, CBI,
    CBTPA, GSP, NAFTA, USMCA
)

; Supporting documentation
{.documentation}
manufacturer_affidavit = ?                           ; Manufacturer affidavit
bill_of_materials = ?                                ; Bill of materials
production_records = ?                               ; Production records

{@origin_certification}

; ═══════════════════════════════════════════════════════════════════════════════
; PGA REQUIREMENT
; ═══════════════════════════════════════════════════════════════════════════════

{@pga_requirement}
; Required fields first
agency = (
    APHIS,                                           ; Animal and Plant Health Inspection Service (USDA)
    ATF,                                             ; Bureau of Alcohol, Tobacco, Firearms and Explosives
    CPSC,                                            ; Consumer Product Safety Commission
    DEA,                                             ; Drug Enforcement Administration
    DOT,                                             ; Department of Transportation
    EPA,                                             ; Environmental Protection Agency
    FDA,                                             ; Food and Drug Administration
    FTC,                                             ; Federal Trade Commission
    FWS,                                             ; Fish and Wildlife Service
    NHTSA,                                           ; National Highway Traffic Safety Administration
    NMFS,                                            ; National Marine Fisheries Service
    TTB                                              ; Alcohol and Tobacco Tax and Trade Bureau
)

; Optional fields
document_type = :                                    ; Document type required
document_number = :                                  ; Document/permit number
issue_date = date                                    ; Issue date
expiration_date = date                               ; Expiration date

; Compliance status
compliant = ?                                        ; Compliant with PGA requirements
compliance_notes = :                                 ; Compliance notes
hold_reason = :                                      ; Reason for hold by PGA

; FDA specific
fda_product_code = :if agency = FDA                  ; FDA product code
fda_pn = :if agency = FDA                            ; FDA Prior Notice number
prior_notice_confirmed = ?:if agency = FDA           ; Prior notice confirmed
affirmation_compliance = ?:if agency = FDA           ; Affirmation of compliance

; USDA/APHIS specific
lacey_act_declaration = ?:if agency = APHIS          ; Lacey Act declaration
phytosanitary_certificate = :if agency = APHIS       ; Phyto certificate number

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMS BOND
; ═══════════════════════════════════════════════════════════════════════════════

{@customs_bond}
; Required fields first
bond_type = (continuous, single_transaction)        ; Bond type
bond_number = !:                                     ; Bond number
bond_amount = !#$:(0..)                              ; Bond amount

; Optional fields
surety_company = :                                   ; Surety company name
surety_code = :                                      ; Surety company code
effective_date = date                                ; Effective date
expiration_date = date                               ; Expiration date
termination_date = date                              ; Termination date

; Principal (importer)
principal_name = !:                                  ; Principal/importer name
principal_id = :                                     ; Principal ID (EIN, SSN)
principal_address = @types.address                   ; Principal address

; Bond status
status = (active, cancelled, expired, suspended, terminated)
status_date = date                                   ; Status date

; Activity
{.activity}
entries_filed = ##:(0..)                             ; Entries filed against bond
total_duties = #$:(0..)                              ; Total duties under bond
claims_filed = ##:(0..)                              ; Claims filed
claims_amount = #$:(0..)                             ; Total claims amount

{@customs_bond}

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMS ENTRY LINE
; ═══════════════════════════════════════════════════════════════════════════════

{@customs_entry_line}
; Required fields first
line_number = !##:(1..)                              ; Line number
hts_number = !:(6..10)                               ; HTS classification
description = !:                                     ; Merchandise description

; Quantity
quantity = !#:(0..)                                  ; Quantity entered
unit_of_measure = :                                  ; Unit of measure
second_quantity = #:(0..)                            ; Second quantity (if required)
second_unit = :                                      ; Second unit of measure

; Value
entered_value = !#$:(0..)                            ; Entered value
charges = #$                                         ; Charges (freight, insurance, etc.)
relationship = :                                     ; Relationship indicator
dutiable_value = #$:(0..)                            ; Dutiable value

; Duty
duty_rate = :                                        ; Duty rate applied
duty_amount = #$:(0..)                               ; Duty amount
ad_valorem = #:(0..100)                              ; Ad valorem rate percentage
specific_rate = #$                                   ; Specific duty rate
compound_rate = :                                    ; Compound rate

; Fees and taxes
{.fees}
merchandise_processing_fee = #$                      ; MPF
harbor_maintenance_fee = #$                          ; HMF
other_fees = #$                                      ; Other fees

{@customs_entry_line}

; Origin
country_of_origin = :(2)                             ; Country of origin code
preferential_treatment = :                           ; SPI code (preferential treatment)

; Manufacturer
manufacturer_id = :                                  ; Manufacturer ID number (MID)
manufacturer_name = :                                ; Manufacturer name
manufacturer_address = :                             ; Manufacturer address

; Marks and numbers
marks_and_numbers = :                                ; Marks and numbers on packages

; Flags
quota = ?                                            ; Subject to quota
antidumping = ?                                      ; Subject to antidumping duty
countervailing = ?                                   ; Subject to countervailing duty

; ═══════════════════════════════════════════════════════════════════════════════
; CUSTOMS ENTRY
; ═══════════════════════════════════════════════════════════════════════════════

{@customs_entry}
; Required fields first
entry_number = !:(11)                                ; Entry number (11 digits: XXX-XXXXXXX-X)
entry_type = (
    01,                                              ; Consumption Entry
    02,                                              ; Consumption - Quota/Visa
    03,                                              ; Consumption - Antidumping/CVD
    06,                                              ; Consumption - FTZ
    07,                                              ; Mail Entry
    11,                                              ; Warehouse Entry
    21,                                              ; Foreign Trade Zone - Admission
    23,                                              ; TIB - Transportation and Exportation
    61,                                              ; Informal Entry
    62,                                              ; Informal - Low Value
    63,                                              ; Personal Use - ATAT
    86                                               ; Vessel Repair Entry
)
entry_date = !date                                   ; Entry date
summary_date = date                                  ; Summary date

; Filer information
filer_code = !:                                      ; Filer code (4 characters)
filer_type = (broker, carrier, importer, service_center)
broker_name = :if filer_type = broker                ; Customs broker name
broker_license = :if filer_type = broker             ; Broker license number

; Importer of record
importer_name = !:                                   ; Importer name
importer_number = !:                                 ; Importer number (EIN, SSN, CBP-assigned)
importer_address = @types.address                    ; Importer address

; Consignee (if different)
consignee_name = :                                   ; Consignee name
consignee_number = :                                 ; Consignee number
consignee_address = @types.address                   ; Consignee address

; Ultimate consignee
ultimate_consignee_name = :                          ; Ultimate consignee name
ultimate_consignee_type = (
    business,
    government,
    individual,
    other
)

; Shipment information
port_of_entry = !:(4)                                ; Port of entry code
port_of_unlading = :(4)                              ; Port of unlading
location_of_goods = :                                ; Location of goods code
foreign_port_of_lading = :                           ; Foreign port of lading
manifest_number = :                                  ; Manifest/bill number
carrier_code = :(4)                                  ; Carrier SCAC
vessel_name = :                                      ; Vessel name
voyage_number = :                                    ; Voyage/flight number
import_date = date                                   ; Import/arrival date

; Mode of transport
mode = (
    10,                                              ; Vessel
    20,                                              ; Rail
    30,                                              ; Truck
    40,                                              ; Air
    50,                                              ; Mail
    60                                               ; Passenger
)

; Entry lines
lines[] = @customs_entry_line                        ; Entry line items

; Entry totals
{.totals}
total_entered_value = #$:(0..)                       ; Total entered value
total_duty = #$:(0..)                                ; Total duty
total_fees = #$:(0..)                                ; Total fees
total_taxes = #$:(0..)                               ; Total taxes
total_amount_due = #$:(0..)                          ; Total amount due

{@customs_entry}

; Bond
bond_type = (continuous, none, single_transaction, term)
bond_number = :if bond_type != none                  ; Bond number

; IT/Cargo Release
it_number = :                                        ; IT number (in-bond)
it_date = date                                       ; IT date
release_date = date                                  ; Cargo release date

; Exam and inspection
{.exam}
exam_required = ?                                    ; Examination required
exam_site = :                                        ; Exam site
exam_date = date                                     ; Exam date
exam_result = (discrepancy, no_discrepancy, pending) ; Exam result
hold_status = (
    agriculture_hold,
    fda_hold,
    intensive_exam,
    no_hold,
    other_pga_hold,
    random_exam
)

{@customs_entry}

; Liquidation
{.liquidation}
liquidated = ?                                       ; Entry liquidated
liquidation_date = date                              ; Liquidation date
liquidation_type = (
    final_liquidation,
    partial_liquidation,
    preliminary
)
protest_filed = ?                                    ; Protest filed
protest_number = :                                   ; Protest number
protest_date = date                                  ; Protest date

{@customs_entry}

; PGA requirements
pga_requirements[] = @pga_requirement                ; PGA compliance requirements

; Origin certification
origin_certifications[] = @origin_certification      ; Origin certificates

; Valuation
valuation = @customs_valuation                       ; Valuation details

; Entry status
status = (
    accepted,
    in_bond,
    liquidated,
    pending,
    rejected,
    released,
    suspended
)
status_date = date                                   ; Status date

; Payment
{.payment}
payment_type = (
    ach,
    check,
    electronic,
    periodic_monthly_statement,
    statement
)
payment_date = date                                  ; Payment date
payment_reference = :                                ; Payment reference
paid_amount = #$:(0..)                               ; Amount paid

{@customs_entry}

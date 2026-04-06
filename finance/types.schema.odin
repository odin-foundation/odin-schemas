; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Finance Common Types
; ═══════════════════════════════════════════════════════════════════════════════
; Reusable type definitions for finance schemas derived from ISO 20022.
; Provides shared structures for accounts, parties, amounts, and identifiers
; used across all finance domain schemas.
; ═══════════════════════════════════════════════════════════════════════════════

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.finance.types"
version = "1.0.0"
title = "Finance Common Types"
description = "Reusable type definitions for financial messaging"

{$derivation}
source[0].authority = "ISO"
source[0].citation = "ISO 20022 Financial Services - Universal Financial Industry Message Scheme"
source[0].url = "https://www.iso20022.org/catalogue-messages"

source[1].authority = "ISO"
source[1].citation = "ISO 4217 Currency Codes"
source[1].url = "https://www.iso.org/iso-4217-currency-codes.html"

source[2].authority = "ISO"
source[2].citation = "ISO 13616 IBAN Standard"
source[2].url = "https://www.iso.org/standard/81090.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
changelog[0].date = 2025-12-16
changelog[0].change = "Initial finance common types schema"
changelog[0].rationale = "Base types derived from ISO 20022 data dictionary"

; ═══════════════════════════════════════════════════════════════════════════════
; MONETARY AMOUNT
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ActiveCurrencyAndAmount / ActiveOrHistoricCurrencyAndAmount

{@amount}
value = !#$                                   ; Monetary value
currency = !:(3)                              ; ISO 4217 currency code

; ═══════════════════════════════════════════════════════════════════════════════
; ACCOUNT IDENTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: AccountIdentification4Choice, CashAccount

{@account}
; Required - at least one identifier
ibans[] = :format iban    ; IBANs (multi-bank, linked accounts)
bbans[] = :                                   ; BBANs (multiple identifiers)
other_ids[] = :                               ; Proprietary identifiers (vendor IDs)

; Account details
name = :                                      ; Account name
currency = :(3)                               ; Account currency (ISO 4217)
type = (cacc, casa, char, cish, comm, loan, mgld, moma, nrex, odft, ondp, sacc, slry, svgs, taxe, tran)

; Account owners
owners[] = {@account_owner}                   ; Account owners (joint accounts)

{@account_owner}
owner_name = !:                               ; Account holder name
owner_id = :                                  ; Account holder identifier

{@account}

:one_of ibans, bbans, other_ids               ; At least one identifier required

; ═══════════════════════════════════════════════════════════════════════════════
; FINANCIAL INSTITUTION IDENTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: FinancialInstitutionIdentification, BranchAndFinancialInstitutionIdentification

{@financial_institution}
; Required - at least one identifier
bics[] = :format bic  ; BICs (multiple SWIFT codes)
leis[] = :format lei                    ; LEIs (historical, merged entities)
clearing_system_ids[] = :                     ; Clearing system IDs (multi-network)
other_ids[] = :                               ; Proprietary identifiers (vendor IDs)

; Institution details
name = :                                      ; Institution name

; Addresses
addresses[] = @address                        ; Addresses (HQ, branches, operations)

; Branches
branches[] = {@fi_branch}                     ; Branches (multiple locations)

{@fi_branch}
id = !:                                       ; Branch identifier
name = :                                      ; Branch name
address = @address                            ; Branch address

{@financial_institution}

:one_of bics, leis, clearing_system_ids, other_ids

; ═══════════════════════════════════════════════════════════════════════════════
; PARTY IDENTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: PartyIdentification, OrganisationIdentification, PersonIdentification

{@party}
name = !:                                     ; Party name

; Organization identifiers
leis[] = :format lei                    ; LEIs (multi-jurisdiction)
bics[] = :format bic  ; BICs (multiple)
tax_ids[] = *:                                ; Tax IDs (multi-jurisdiction)
registration_numbers[] = :                    ; Registration numbers (multi-jurisdiction)

; Person identifiers
date_of_birth = *date                         ; Birth date (individuals only)
place_of_birth = :                            ; Birth place
country_of_birth = :(2)                       ; Birth country (ISO 3166-1)
nationalities[] = :(2)                        ; Nationalities (dual/multi-citizenship)

; Contact
emails[] = *@email                            ; Email addresses (multiple contacts)
phones[] = *@phone                            ; Phone numbers (multiple contacts)
addresses[] = @address                        ; Physical addresses (HQ, operations)

{@party}

; ═══════════════════════════════════════════════════════════════════════════════
; REMITTANCE INFORMATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: RemittanceInformation

{@remittance_info}
unstructured = :                              ; Free-form remittance text

; Structured remittance
referred_documents[] = {@referred_document}   ; Documents (multiple invoices, POs)

{@referred_document}
type = !(aroi, bold, cinv, cmcn, cnfa, cren, debn, disp, dnfa, hiri, msin, prof, puor, quot, sbin, sprr, tish)
number = !:                                   ; Document number
date = date                                   ; Document date

{@remittance_info}

; Creditor reference
{.creditor_reference}
type = (radm, rpin, scor)                     ; Reference type
reference = :                                 ; Reference value

{@remittance_info}

; ═══════════════════════════════════════════════════════════════════════════════
; DATE AND TIME
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ISODate, ISODateTime

{@effective_date}
date = !date                                  ; Value date
time = time                                   ; Optional time component

; ═══════════════════════════════════════════════════════════════════════════════
; MESSAGE IDENTIFICATION
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: GroupHeader, MessageIdentification

{@message_header}
message_id = !:                               ; Unique message identifier
created = !timestamp                          ; Creation date/time

; Batch information
batch = ?                                     ; Batch booking indicator
transaction_count = ##:(1..)                  ; Number of transactions
control_sum = #$                              ; Sum of amounts for validation

; Initiating party
initiating_party = @party                     ; Message initiator

; ═══════════════════════════════════════════════════════════════════════════════
; STATUS CODES
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: TransactionStatus, PaymentStatus

{@transaction_status}
= @status_record                              ; Inherits status tracking fields

; ISO 20022 transaction status codes
status = !(accp, acsc, acsp, actc, acwc, acwp, canc, pdng, rcvd, rjct)
effective_date = timestamp                    ; Status effective date/time

; Status code meanings:
; accp = Accepted Customer Profile
; acsc = Accepted Settlement Completed
; acsp = Accepted Settlement In Progress
; actc = Accepted Technical Validation
; acwc = Accepted With Change
; acwp = Accepted Without Posting
; canc = Cancelled
; pdng = Pending
; rcvd = Received
; rjct = Rejected

; ═══════════════════════════════════════════════════════════════════════════════
; CHARGES
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: Charges, ChargeType

{@charges}
amounts[] = @amount                           ; Charge amounts (multiple fees)
type = (brkf, comm, cond, debt, dist, dlvy, levy, locl, marg, othr, perc, post, prem, regl, ship, stam, stor, tran)
bearer = (cred, debt, shar, slev)             ; Who bears the charges
agent = @financial_institution                ; Agent levying the charge

; ═══════════════════════════════════════════════════════════════════════════════
; EXCHANGE RATE
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: ExchangeRate

{@exchange_rate}
source_currency = !:(3)                       ; Source currency (ISO 4217)
target_currency = !:(3)                       ; Target currency (ISO 4217)
rate = !#.6                                   ; Exchange rate (6 decimal places)
rate_type = (agrd, exot, sale)                ; Rate type
contract_id = :                               ; FX contract reference
quotation_date = date                         ; Rate quotation date

; ═══════════════════════════════════════════════════════════════════════════════
; REGULATORY REPORTING
; ═══════════════════════════════════════════════════════════════════════════════
; ISO 20022: RegulatoryReporting

{@regulatory_reporting}
authority = :                                 ; Reporting authority name
authority_country = :(2)                      ; Authority country (ISO 3166-1)
code = :                                      ; Regulatory code
amount = @amount                              ; Reported amount
information = :                               ; Additional information
date = date                                   ; Reporting date


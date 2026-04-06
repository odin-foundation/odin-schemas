; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Crypto / Digital Asset Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Cryptocurrency and digital asset insurance covering crypto theft/crime, private
; key loss, smart contract failure, custodial E&O, NFT coverage, DeFi protocol
; coverage, and stablecoin depeg across hot, warm, and cold storage.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../business.schema.odin" as entity
@import "../../coverages/coverage.schema.odin" as coverage

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.crypto-digital-asset"
version = "1.0.0"
title = "Crypto / Digital Asset Insurance Schema"
description = "Comprehensive coverage for cryptocurrency, digital tokens, NFTs, and blockchain-based assets"

{$derivation}
source[0].authority = "U.S. Securities and Exchange Commission"
source[0].citation = "Framework for Investment Contract Analysis of Digital Assets"
source[0].url = "https://www.sec.gov/corpfin/framework-investment-contract-analysis-digital-assets"

source[1].authority = "U.S. Commodity Futures Trading Commission"
source[1].citation = "Digital Assets Primer"
source[1].url = "https://www.cftc.gov/digitalassets/index.htm"

source[2].authority = "National Institute of Standards and Technology"
source[2].citation = "NISTIR 8301: Blockchain Networks: Token Design and Management Overview"
source[2].url = "https://csrc.nist.gov/pubs/ir/8301/final"

source[3].authority = "American Institute of CPAs"
source[3].citation = "SOC 2 Type II Trust Services Criteria"
source[3].url = "https://www.aicpa.org/interestareas/frc/assuranceadvisoryservices/sorhome"

source[4].authority = "Financial Crimes Enforcement Network"
source[4].citation = "Guidance on Virtual Currency"
source[4].url = "https://www.fincen.gov/resources/statutes-and-regulations/guidance"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Complete crypto/digital asset schema derived from SEC, CFTC, NIST, and AICPA public guidance"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial crypto/digital asset insurance schema"
changelog[0].rationale = "Comprehensive coverage structure for emerging digital asset risks"

; ═══════════════════════════════════════════════════════════════════════════════
; Digital Asset Definition
; ═══════════════════════════════════════════════════════════════════════════════
; Defines the fundamental characteristics of a digital asset being insured

{@digital_asset}
asset_id = :                              ; Unique identifier for the digital asset

; ───────────────────────────────────────────────────────────────────────────────
; Asset Classification
; ───────────────────────────────────────────────────────────────────────────────
asset_type = (
    cryptocurrency,               ; Bitcoin, Ethereum, etc.
    defi_position,                ; DeFi protocol stakes, liquidity positions
    governance_token,             ; DAO voting tokens
    nft,                          ; Non-fungible tokens
    security_token,               ; Tokenized securities
    stablecoin,                   ; USD-pegged or algorithmic stables
    utility_token,                ; Platform utility tokens
    wrapped_asset                 ; Wrapped versions (WBTC, etc.)
)

asset_name = :                            ; Full name of the digital asset
asset_symbol = :                          ; Trading symbol or ticker

; Regulatory Classification (SEC/CFTC)
regulatory_classification = (
    commodity,                    ; CFTC jurisdiction (Bitcoin, Ethereum)
    currency,                     ; Money transmission rules apply
    security,                     ; SEC jurisdiction
    uncertain,                    ; Classification pending/unclear
    utility                       ; Utility token (Howey test not met)
)

; ───────────────────────────────────────────────────────────────────────────────
; Blockchain Details
; ───────────────────────────────────────────────────────────────────────────────
blockchain = (
    arbitrum,
    avalanche,
    base,
    binance_smart_chain,
    bitcoin,
    cardano,
    ethereum,
    optimism,
    polygon,
    solana,
    tron,
    other
)

blockchain_other = ::if blockchain = other    ; Specify blockchain if "other" selected

; Token Contract (for ERC-20, ERC-721, etc.)
contract_address = :       ; 0x + 40 hex chars for Ethereum-style
token_standard = (
    bep20,                        ; Binance Smart Chain
    brc20,                        ; Bitcoin Ordinals
    erc1155,                      ; Ethereum multi-token
    erc20,                        ; Ethereum fungible
    erc721,                       ; Ethereum NFT
    native,                       ; Native blockchain asset
    spl,                          ; Solana
    trc20,                        ; Tron
    other
)

; ───────────────────────────────────────────────────────────────────────────────
; Stablecoin Details
; ───────────────────────────────────────────────────────────────────────────────
{.stablecoin}
peg_type = (
    algorithmic,                  ; Algorithmic stabilization (higher risk)
    commodity_backed,             ; Gold, silver backed
    crypto_backed,                ; Crypto collateralized (DAI-style)
    fiat_backed,                  ; USD, EUR reserves
    hybrid                        ; Multiple mechanisms
):if asset_type = stablecoin

peg_currency = :(3):if asset_type = stablecoin    ; USD, EUR, etc.
issuer = ::if asset_type = stablecoin             ; Entity that issued the stablecoin
proof_of_reserves = ?:if asset_type = stablecoin  ; Whether reserves are independently verified
last_attestation_date = date:if stablecoin.proof_of_reserves = true  ; Most recent attestation date
attestation_provider = ::if stablecoin.proof_of_reserves = true      ; Firm providing attestation

{@digital_asset}

; ───────────────────────────────────────────────────────────────────────────────
; NFT Details
; ───────────────────────────────────────────────────────────────────────────────
{.nft}
collection_name = ::if asset_type = nft           ; Name of the NFT collection
token_id = ::if asset_type = nft                  ; Token identifier within collection
rarity_rank = ##:if asset_type = nft              ; Rarity ranking within collection
metadata_storage = (
    arweave,
    centralized,
    ipfs,
    on_chain
):if asset_type = nft
royalty_percentage = #:(0..100):if asset_type = nft  ; Creator royalty on secondary sales
creator_address = ::if asset_type = nft           ; Blockchain address of NFT creator

{@digital_asset}

; ───────────────────────────────────────────────────────────────────────────────
; DeFi Position Details
; ───────────────────────────────────────────────────────────────────────────────
{.defi}
protocol_name = ::if asset_type = defi_position   ; Name of DeFi protocol
protocol_type = (
    bridge,                       ; Cross-chain bridge
    derivatives,                  ; Options, perpetuals
    lending,                      ; Aave, Compound style
    liquidity_pool,               ; DEX liquidity provision
    staking,                      ; Proof of stake
    yield_aggregator              ; Yearn-style aggregators
):if asset_type = defi_position
position_type = (
    borrower,
    lender,
    liquidity_provider,
    staker
):if asset_type = defi_position
pool_address = ::if asset_type = defi_position    ; Smart contract address of pool
tvl_at_entry = #$.18:(0..):if asset_type = defi_position  ; Total value locked when entered
audit_status = (audited, not_audited, partial):if asset_type = defi_position  ; Security audit status
auditor = ::if defi.audit_status = audited        ; Name of auditing firm

{@digital_asset}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
quantity = #               ; Amount held (can be fractional)
unit_value = #$.18:(0..)            ; Per-unit value at valuation time
total_value = #$.18:(0..)           ; Total insured value
valuation_currency = :(3) "USD"
valuation_date = date                     ; Date of valuation
valuation_source = (
    appraisal,                    ; Professional appraisal (NFTs)
    average_price,                ; Multiple exchange average
    cost_basis,                   ; Original acquisition cost
    exchange_rate,                ; Specific exchange
    floor_price,                  ; Collection floor (NFTs)
    last_sale                     ; Most recent sale
)
exchange_source = ::if valuation.valuation_source = exchange_rate  ; Name of exchange used
price_oracle = :                          ; Chainlink, etc.

{@digital_asset}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Wallet
; ═══════════════════════════════════════════════════════════════════════════════
; Defines wallet characteristics, storage method, and security configuration

{@crypto_wallet}
wallet_id = :                             ; Unique identifier for the wallet

; ───────────────────────────────────────────────────────────────────────────────
; Wallet Type and Storage
; ───────────────────────────────────────────────────────────────────────────────
wallet_type = (
    cold,                         ; Completely offline
    custodial,                    ; Third-party managed
    exchange,                     ; Exchange-held
    hardware,                     ; Ledger, Trezor, etc.
    hot,                          ; Online, connected
    institutional,                ; Institutional-grade (Fireblocks, etc.)
    mpc,                          ; Multi-party computation
    multi_sig,                    ; Multi-signature
    paper,                        ; Paper wallet
    smart_contract,               ; Smart contract wallet
    warm                          ; Semi-connected
)

storage_method = (
    air_gapped,                   ; No network connectivity
    cloud_hosted,                 ; Cloud-based (AWS, etc.)
    exchange_custody,             ; Exchange holds keys
    hardware_device,              ; Physical hardware wallet
    hsm,                          ; Hardware Security Module
    mobile_app,                   ; Mobile wallet app
    on_premises,                  ; Self-hosted infrastructure
    paper,                        ; Physical paper backup
    third_party_custody,          ; Qualified custodian
    web_browser                   ; Browser extension wallet
)

wallet_provider = :                       ; Ledger, Trezor, Fireblocks, etc.
wallet_address = :                        ; Public address (may be masked)

; ───────────────────────────────────────────────────────────────────────────────
; Multi-Signature Configuration
; ───────────────────────────────────────────────────────────────────────────────
{.multi_sig}
enabled = ?                               ; Whether multi-signature is enabled
threshold = ##:if multi_sig.enabled = true         ; M of N required
total_signers = ##:if multi_sig.enabled = true     ; N total signers
signer_types[] = (
    employee,
    executive,
    external_director,
    third_party_custodian
):if multi_sig.enabled = true
time_lock_hours = ##:if multi_sig.enabled = true  ; Delay before execution
geographic_distribution = ?:if multi_sig.enabled = true    ; Signers in different locations

{@crypto_wallet}

; ───────────────────────────────────────────────────────────────────────────────
; Key Management
; ───────────────────────────────────────────────────────────────────────────────
{.key_management}
key_generation = (
    ceremony,                     ; Formal key ceremony
    hardware_rng,                 ; Hardware random number generator
    hsm_generated,                ; Generated within HSM
    software_rng,                 ; Software random
    third_party                   ; Custodian generated
)
key_storage = (
    distributed,                  ; Shamir's secret sharing
    encrypted_file,               ; Encrypted on disk
    hardware_wallet,              ; Hardware device
    hsm,                          ; Hardware Security Module
    memory_only,                  ; RAM only
    mpc,                          ; Multi-party computation
    paper_backup                  ; Written/printed
)
backup_exists = ?                         ; Whether key backup exists
backup_location = (
    bank_safe_deposit,
    distributed_locations,
    encrypted_cloud,
    fireproof_safe,
    third_party_vault
):if key_management.backup_exists = true
backup_encryption = ?:if key_management.backup_exists = true  ; Whether backup is encrypted
backup_tested = ?:if key_management.backup_exists = true      ; Whether backup has been tested
last_backup_test = date:if key_management.backup_tested = true  ; Date of most recent backup test
seed_phrase_stored = ?                    ; Whether seed phrase is stored
seed_phrase_location = ::if key_management.seed_phrase_stored = true  ; Location of seed phrase storage

{@crypto_wallet}

; ───────────────────────────────────────────────────────────────────────────────
; Wallet Exposure
; ───────────────────────────────────────────────────────────────────────────────
{.exposure}
maximum_value = #$.18:(0..)         ; Maximum value stored
average_value = #$.18:(0..)         ; Average value stored
percentage_of_holdings = ##:(0..100)  ; % of total digital assets
assets_held[] = @digital_asset            ; Digital assets stored in this wallet

{@crypto_wallet}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Custodian
; ═══════════════════════════════════════════════════════════════════════════════
; Third-party custodian details for institutional custody arrangements

{@crypto_custodian}
custodian_id = :                          ; Unique identifier for the custodian

; ───────────────────────────────────────────────────────────────────────────────
; Custodian Identity
; ───────────────────────────────────────────────────────────────────────────────
legal_name = :                            ; Legal name of custodian entity
custodian_type = (
    bank,                         ; Traditional bank with crypto custody
    broker_dealer,                ; SEC-registered broker-dealer
    exchange,                     ; Crypto exchange custody
    qualified_custodian,          ; SEC Rule 206(4)-2 qualified
    trust_company                 ; State-chartered trust company
)

; Regulatory Status
jurisdiction = :                          ; Regulatory jurisdiction
regulator = :                             ; OCC, state banking dept, etc.
charter_type = (
    federal_bank,
    foreign,
    money_transmitter,
    national_trust,
    state_bank,
    state_trust
)
license_number = *:                       ; Regulatory license or charter number

; ───────────────────────────────────────────────────────────────────────────────
; Custodian Security Standards
; ───────────────────────────────────────────────────────────────────────────────
{.certifications}
soc1_type2 = ?                            ; SOC 1 Type II certified
soc1_date = date:if certifications.soc1_type2 = true  ; Date of SOC 1 report
soc2_type2 = ?                            ; SOC 2 Type II certified
soc2_date = date:if certifications.soc2_type2 = true  ; Date of SOC 2 report
soc2_categories[] = (
    availability,
    confidentiality,
    privacy,
    processing_integrity,
    security
):if certifications.soc2_type2 = true
iso_27001 = ?                             ; ISO 27001 certified
iso_27001_date = date:if certifications.iso_27001 = true  ; Date of ISO 27001 certification
pci_dss = ?                               ; PCI DSS compliant
fips_140_2 = ?                            ; FIPS 140-2 validated
fips_140_2_level = ##:if certifications.fips_140_2 = true  ; FIPS 140-2 security level

{@crypto_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Proof of Reserves
; ───────────────────────────────────────────────────────────────────────────────
{.proof_of_reserves}
provides_por = ?                          ; Whether custodian provides proof of reserves
por_type = (
    attestation,                  ; Third-party attestation
    merkle_tree,                  ; Cryptographic proof
    real_time                     ; On-chain verifiable
):if proof_of_reserves.provides_por = true
por_frequency = (
    annual,
    daily,
    monthly,
    quarterly,
    real_time
):if proof_of_reserves.provides_por = true
por_auditor = ::if proof_of_reserves.provides_por = true  ; Firm providing proof of reserves
last_por_date = date:if proof_of_reserves.provides_por = true  ; Date of most recent PoR
reserve_ratio = #:if proof_of_reserves.provides_por = true   ; 1.0 = 100%

{@crypto_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Insurance Coverage (Custodian's Own)
; ───────────────────────────────────────────────────────────────────────────────
{.custodian_insurance}
crime_coverage = ?                        ; Whether custodian has crime coverage
crime_limit = #$:(0..):if custodian_insurance.crime_coverage = true  ; Crime coverage limit
specie_coverage = ?                       ; Whether custodian has specie coverage
specie_limit = #$:(0..):if custodian_insurance.specie_coverage = true  ; Specie coverage limit
eo_coverage = ?                           ; Whether custodian has E&O coverage
eo_limit = #$:(0..):if custodian_insurance.eo_coverage = true  ; E&O coverage limit
coverage_per_client = #$:(0..)            ; Per-client coverage allocation
lloyd_backed = ?                          ; Whether backed by Lloyd's of London
insurer_names[] = :                       ; Names of insurance carriers

{@crypto_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Details
; ───────────────────────────────────────────────────────────────────────────────
years_in_operation = ##                   ; Number of years custodian has operated
assets_under_custody = #$:(0..)           ; Total assets under custody
client_count = ##                         ; Number of clients
cold_storage_percentage = ##:(0..100)     ; Percentage of assets in cold storage
segregated_accounts = ?                   ; Whether client accounts are segregated
bankruptcy_remote = ?                     ; Assets protected from custodian bankruptcy

{@crypto_custodian}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Security Controls
; ═══════════════════════════════════════════════════════════════════════════════
; Security measures and controls for digital asset protection

{@crypto_security_controls}
controls_id = :                           ; Unique identifier for security controls set

; ───────────────────────────────────────────────────────────────────────────────
; Access Controls
; ───────────────────────────────────────────────────────────────────────────────
{.access}
mfa_enabled = ?                           ; Whether multi-factor authentication is enabled
mfa_types[] = (
    biometric,
    email,
    hardware_token,
    passkey,
    phone,
    sms,
    software_totp
)
hardware_keys_required = ?                ; YubiKey, etc.
biometric_authentication = ?              ; Whether biometric authentication is used
ip_whitelisting = ?                       ; Whether IP whitelisting is enforced
geo_restrictions = ?                      ; Whether geographic restrictions apply
restricted_countries[] = ::if access.geo_restrictions = true  ; Countries that are restricted
session_timeout_minutes = ##              ; Session timeout in minutes
device_binding = ?                        ; Known device requirement

{@crypto_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Controls
; ───────────────────────────────────────────────────────────────────────────────
{.transaction}
withdrawal_whitelist = ?                  ; Only pre-approved addresses
whitelist_time_lock_hours = ##:if transaction.withdrawal_whitelist = true  ; Hours before new address active
daily_withdrawal_limit = #$:(0..)         ; Maximum daily withdrawal amount
per_transaction_limit = #$:(0..)          ; Maximum per transaction amount
dual_authorization_threshold = #$:(0..)   ; Amount requiring dual authorization
cooling_off_period_hours = ##             ; Waiting period before withdrawal executes
velocity_controls = ?                     ; Rate limiting
travel_rule_compliant = ?                 ; FATF travel rule

{@crypto_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Infrastructure Security
; ───────────────────────────────────────────────────────────────────────────────
{.infrastructure}
dedicated_hardware = ?                    ; Whether dedicated hardware is used
hsm_fips_validated = ?                    ; Whether HSM is FIPS validated
hsm_level = ##:if infrastructure.hsm_fips_validated = true  ; FIPS validation level
air_gapped_signing = ?                    ; Whether signing occurs on air-gapped system
secure_enclave = ?                        ; Whether secure enclave technology is used
tamper_evident_hardware = ?               ; Whether tamper-evident hardware is used
physical_security_tier = (
    data_center_tier1,
    data_center_tier2,
    data_center_tier3,
    data_center_tier4,
    vault
)
geographic_redundancy = ?                 ; Whether geographically redundant systems exist
disaster_recovery_tested = ?              ; Whether disaster recovery plan has been tested
dr_test_frequency = (annual, monthly, quarterly):if infrastructure.disaster_recovery_tested = true  ; DR testing frequency

{@crypto_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Monitoring and Detection
; ───────────────────────────────────────────────────────────────────────────────
{.monitoring}
real_time_monitoring = ?                  ; Whether real-time monitoring is active
blockchain_analytics = ?                  ; Chainalysis, Elliptic, etc.
analytics_provider = ::if monitoring.blockchain_analytics = true  ; Name of analytics provider
anomaly_detection = ?                     ; Whether anomaly detection is deployed
24x7_security_operations = ?              ; Whether 24/7 security operations center exists
incident_response_plan = ?                ; Whether incident response plan exists
ir_plan_tested = ?:if monitoring.incident_response_plan = true  ; Whether IR plan has been tested
siem_deployed = ?                         ; Whether SIEM system is deployed
threat_intelligence = ?                   ; Whether threat intelligence feeds are used

{@crypto_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Employee Controls
; ───────────────────────────────────────────────────────────────────────────────
{.employee}
background_checks = ?                     ; Whether background checks are performed
background_check_scope = (
    basic,
    comprehensive,
    enhanced
):if employee.background_checks = true
security_training = ?                     ; Whether security training is provided
training_frequency = (annual, monthly, quarterly):if employee.security_training = true  ; Training frequency
phishing_simulations = ?                  ; Whether phishing simulations are conducted
separation_of_duties = ?                  ; Whether separation of duties is enforced
privileged_access_management = ?          ; Whether PAM system is used
insider_threat_program = ?                ; Whether insider threat program exists

{@crypto_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Smart Contract Security (for DeFi interactions)
; ───────────────────────────────────────────────────────────────────────────────
{.smart_contract}
audit_required = ?                        ; Whether smart contract audit is required
approved_auditors[] = ::if smart_contract.audit_required = true  ; List of approved audit firms
formal_verification = ?                   ; Whether formal verification is required
bug_bounty_program = ?                    ; Whether bug bounty program exists
time_lock_governance = ?                  ; Whether time-lock governance is enforced
admin_key_controls = (
    dao_controlled,
    gnosis_safe,
    multi_sig,
    renounced,
    single_admin
)
upgrade_controls = (
    immutable,
    proxy_upgradeable,
    time_locked_upgrade
)

{@crypto_security_controls}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════
; Main coverage structure for crypto/digital asset insurance

{@crypto_coverage}
coverage_id = :                           ; Unique identifier for coverage structure

; ───────────────────────────────────────────────────────────────────────────────
; Policy Aggregate
; ───────────────────────────────────────────────────────────────────────────────
policy_aggregate = #$:(0..)               ; Total policy aggregate limit
retention_base = #$:(0..)                 ; Base retention/deductible amount

; ═══════════════════════════════════════════════════════════════════════════════
; FIRST PARTY COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Crypto Theft / Crime Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.theft}
included = ?                              ; Whether theft coverage is included
sublimit = #$:(0..):if theft.included = true  ; Coverage sublimit for theft
retention = #$:(0..):if theft.included = true  ; Retention/deductible for theft
coinsurance_percentage = ##:(0..50):if theft.included = true  ; Coinsurance percentage

; Covered Storage Types
hot_wallet = ?:if theft.included = true   ; Whether hot wallet storage is covered
warm_wallet = ?:if theft.included = true  ; Whether warm wallet storage is covered
cold_storage = ?:if theft.included = true  ; Whether cold storage is covered
exchange_held = ?:if theft.included = true  ; Whether exchange-held assets are covered
custodian_held = ?:if theft.included = true  ; Whether custodian-held assets are covered

; Covered Perils
external_hack = ?:if theft.included = true  ; Whether external hacks are covered
insider_theft = ?:if theft.included = true  ; Whether insider theft is covered
physical_theft = ?:if theft.included = true  ; Whether physical theft is covered
ransomware = ?:if theft.included = true   ; Whether ransomware attacks are covered
sim_swap = ?:if theft.included = true     ; Whether SIM swap attacks are covered

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Private Key Loss / Compromise
; ───────────────────────────────────────────────────────────────────────────────
{.key_loss}
included = ?                              ; Whether key loss coverage is included
sublimit = #$:(0..):if key_loss.included = true  ; Coverage sublimit for key loss
retention = #$:(0..):if key_loss.included = true  ; Retention/deductible for key loss

; Covered Causes
accidental_destruction = ?:if key_loss.included = true  ; Whether accidental destruction is covered
device_failure = ?:if key_loss.included = true  ; Whether device failure is covered
natural_disaster = ?:if key_loss.included = true  ; Whether natural disaster is covered
seed_phrase_loss = ?:if key_loss.included = true  ; Whether seed phrase loss is covered
hardware_wallet_failure = ?:if key_loss.included = true  ; Whether hardware wallet failure is covered

; Exclusions
user_negligence_excluded = ?:if key_loss.included = true  ; Whether user negligence is excluded
intentional_destruction_excluded = ?:if key_loss.included = true  ; Whether intentional destruction is excluded

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Social Engineering / Phishing
; ───────────────────────────────────────────────────────────────────────────────
{.social_engineering}
included = ?                              ; Whether social engineering coverage is included
sublimit = #$:(0..):if social_engineering.included = true  ; Coverage sublimit for social engineering
retention = #$:(0..):if social_engineering.included = true  ; Retention/deductible for social engineering

; Covered Scenarios
phishing_attacks = ?:if social_engineering.included = true  ; Whether phishing attacks are covered
impersonation = ?:if social_engineering.included = true  ; Whether impersonation is covered
fake_wallet_apps = ?:if social_engineering.included = true  ; Whether fake wallet apps are covered
fake_customer_support = ?:if social_engineering.included = true  ; Whether fake support scams are covered
address_poisoning = ?:if social_engineering.included = true  ; Whether address poisoning is covered
approval_phishing = ?:if social_engineering.included = true  ; Whether approval phishing is covered

; Verification Requirements
callback_verification_required = ?:if social_engineering.included = true  ; Whether callback verification is required
verification_threshold = #$:if social_engineering.callback_verification_required = true  ; Amount threshold requiring verification

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Smart Contract Failure / Exploit Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.smart_contract}
included = ?                              ; Whether smart contract coverage is included
sublimit = #$:(0..):if smart_contract.included = true  ; Coverage sublimit for smart contract failures
retention = #$:(0..):if smart_contract.included = true  ; Retention/deductible for smart contract failures
coinsurance_percentage = ##:(0..50):if smart_contract.included = true  ; Coinsurance percentage

; Covered Events
code_exploit = ?:if smart_contract.included = true  ; Whether code exploits are covered
reentrancy_attack = ?:if smart_contract.included = true  ; Whether reentrancy attacks are covered
oracle_manipulation = ?:if smart_contract.included = true  ; Whether oracle manipulation is covered
flash_loan_attack = ?:if smart_contract.included = true  ; Whether flash loan attacks are covered
governance_attack = ?:if smart_contract.included = true  ; Whether governance attacks are covered
bridge_exploit = ?:if smart_contract.included = true  ; Whether bridge exploits are covered
logic_error = ?:if smart_contract.included = true  ; Whether logic errors are covered

; Requirements
audit_required = ?:if smart_contract.included = true  ; Whether audit is required for coverage
approved_protocols_only = ?:if smart_contract.included = true  ; Whether only approved protocols are covered
approved_protocols[] = ::if smart_contract.approved_protocols_only = true  ; List of approved protocols

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Custodian Failure / Insolvency
; ───────────────────────────────────────────────────────────────────────────────
{.custodian_failure}
included = ?                              ; Whether custodian failure coverage is included
sublimit = #$:(0..):if custodian_failure.included = true  ; Coverage sublimit for custodian failure
retention = #$:(0..):if custodian_failure.included = true  ; Retention/deductible for custodian failure
waiting_period_days = ##:if custodian_failure.included = true  ; Waiting period before coverage applies

; Covered Events
custodian_bankruptcy = ?:if custodian_failure.included = true  ; Whether custodian bankruptcy is covered
custodian_fraud = ?:if custodian_failure.included = true  ; Whether custodian fraud is covered
regulatory_seizure = ?:if custodian_failure.included = true  ; Whether regulatory seizure is covered
operational_failure = ?:if custodian_failure.included = true  ; Whether operational failure is covered

; Requirements
qualified_custodian_only = ?:if custodian_failure.included = true  ; Whether only qualified custodians are covered
soc2_required = ?:if custodian_failure.included = true  ; Whether SOC 2 certification is required

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Stablecoin Depeg Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.stablecoin_depeg}
included = ?                              ; Whether stablecoin depeg coverage is included
sublimit = #$:(0..):if stablecoin_depeg.included = true  ; Coverage sublimit for stablecoin depeg
retention = #$:(0..):if stablecoin_depeg.included = true  ; Retention/deductible for stablecoin depeg

; Trigger Conditions
depeg_threshold_percentage = ##:(0..100):if stablecoin_depeg.included = true  ; % off peg
depeg_duration_hours = ##:if stablecoin_depeg.included = true       ; Must maintain depeg

; Covered Stablecoins
approved_stablecoins[] = ::if stablecoin_depeg.included = true  ; List of approved stablecoins
algorithmic_excluded = ?:if stablecoin_depeg.included = true  ; Whether algorithmic stablecoins are excluded

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; NFT-Specific Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.nft}
included = ?                              ; Whether NFT coverage is included
sublimit = #$:(0..):if nft.included = true  ; Coverage sublimit for NFTs
retention = #$:(0..):if nft.included = true  ; Retention/deductible for NFTs

; Valuation Basis
valuation_basis = (
    agreed_value,                 ; Pre-agreed scheduled amount
    cost_basis,                   ; Original purchase price
    floor_price,                  ; Collection floor
    last_sale,                    ; Most recent comparable
    professional_appraisal        ; Third-party appraisal
):if nft.included = true

; Covered Perils
theft = ?:if nft.included = true          ; Whether NFT theft is covered
smart_contract_exploit = ?:if nft.included = true  ; Whether smart contract exploits are covered
metadata_loss = ?:if nft.included = true  ; Whether metadata loss is covered
marketplace_hack = ?:if nft.included = true  ; Whether marketplace hacks are covered
counterfeit_sale = ?:if nft.included = true  ; Whether counterfeit sales are covered
title_defect = ?:if nft.included = true   ; Whether title defects are covered

; Market Value Fluctuation
market_value_covered = ?:if nft.included = true   ; Very rare/expensive

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Specie Coverage (Physical Storage Media)
; ───────────────────────────────────────────────────────────────────────────────
{.specie}
included = ?                              ; Whether specie coverage is included
sublimit = #$:(0..):if specie.included = true  ; Coverage sublimit for specie
retention = #$:(0..):if specie.included = true  ; Retention/deductible for specie

; Covered Physical Media
hardware_wallets = ?:if specie.included = true  ; Whether hardware wallets are covered
paper_wallets = ?:if specie.included = true  ; Whether paper wallets are covered
steel_backups = ?:if specie.included = true  ; Whether steel backups are covered
hsm_devices = ?:if specie.included = true  ; Whether HSM devices are covered

; Covered Perils
physical_theft = ?:if specie.included = true  ; Whether physical theft is covered
fire_damage = ?:if specie.included = true  ; Whether fire damage is covered
water_damage = ?:if specie.included = true  ; Whether water damage is covered
natural_disaster = ?:if specie.included = true  ; Whether natural disaster is covered
accidental_destruction = ?:if specie.included = true  ; Whether accidental destruction is covered

; Storage Requirements
vault_required = ?:if specie.included = true  ; Whether vault storage is required
insurance_vault_standards = ?:if specie.included = true  ; Whether insurance vault standards must be met

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Business Interruption
; ───────────────────────────────────────────────────────────────────────────────
{.business_interruption}
included = ?                              ; Whether business interruption coverage is included
sublimit = #$:(0..):if business_interruption.included = true  ; Coverage sublimit for business interruption
retention = #$:(0..):if business_interruption.included = true  ; Retention/deductible for business interruption
waiting_period_hours = ##:if business_interruption.included = true  ; Hours before coverage begins
period_of_restoration_days = ##:if business_interruption.included = true  ; Maximum coverage period in days

; Covered Events
wallet_compromise = ?:if business_interruption.included = true  ; Whether wallet compromise is covered
custodian_outage = ?:if business_interruption.included = true  ; Whether custodian outage is covered
blockchain_network_issues = ?:if business_interruption.included = true  ; Whether blockchain issues are covered
exchange_downtime = ?:if business_interruption.included = true  ; Whether exchange downtime is covered

{@crypto_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; THIRD PARTY COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Custodial Errors & Omissions
; ───────────────────────────────────────────────────────────────────────────────
{.custodial_eo}
included = ?                              ; Whether custodial E&O coverage is included
sublimit = #$:(0..):if custodial_eo.included = true  ; Coverage sublimit for custodial E&O
retention = #$:(0..):if custodial_eo.included = true  ; Retention/deductible for custodial E&O

; Covered Acts
negligent_custody = ?:if custodial_eo.included = true  ; Whether negligent custody is covered
breach_of_fiduciary = ?:if custodial_eo.included = true  ; Whether breach of fiduciary duty is covered
failure_to_execute = ?:if custodial_eo.included = true  ; Whether failure to execute is covered
key_management_error = ?:if custodial_eo.included = true  ; Whether key management errors are covered
misappropriation = ?:if custodial_eo.included = true  ; Whether misappropriation is covered

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Defense and Penalties
; ───────────────────────────────────────────────────────────────────────────────
{.regulatory}
included = ?                              ; Whether regulatory coverage is included
sublimit = #$:(0..):if regulatory.included = true  ; Coverage sublimit for regulatory defense
retention = #$:(0..):if regulatory.included = true  ; Retention/deductible for regulatory defense

; Covered Regulators
sec = ?:if regulatory.included = true     ; Whether SEC actions are covered
cftc = ?:if regulatory.included = true    ; Whether CFTC actions are covered
fincen = ?:if regulatory.included = true  ; Whether FinCEN actions are covered
state_regulators = ?:if regulatory.included = true  ; Whether state regulator actions are covered
ofac = ?:if regulatory.included = true    ; Whether OFAC actions are covered
international_regulators = ?:if regulatory.included = true  ; Whether international regulator actions are covered

; Coverage Components
defense_costs = ?:if regulatory.included = true  ; Whether defense costs are covered
civil_penalties = ?:if regulatory.included = true  ; Whether civil penalties are covered
disgorgement = ?:if regulatory.included = true  ; Whether disgorgement is covered

{@crypto_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Technology Errors & Omissions
; ───────────────────────────────────────────────────────────────────────────────
{.tech_eo}
included = ?                              ; Whether technology E&O coverage is included
sublimit = #$:(0..):if tech_eo.included = true  ; Coverage sublimit for technology E&O
retention = #$:(0..):if tech_eo.included = true  ; Retention/deductible for technology E&O

; For Technology Service Providers
smart_contract_development = ?:if tech_eo.included = true  ; Whether smart contract development is covered
wallet_software = ?:if tech_eo.included = true  ; Whether wallet software is covered
protocol_development = ?:if tech_eo.included = true  ; Whether protocol development is covered
security_services = ?:if tech_eo.included = true  ; Whether security services are covered
audit_services = ?:if tech_eo.included = true  ; Whether audit services are covered

{@crypto_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Exposure Profile
; ═══════════════════════════════════════════════════════════════════════════════
; Aggregate exposure information for underwriting

{@crypto_exposure}
exposure_id = :                           ; Unique identifier for exposure profile

; ───────────────────────────────────────────────────────────────────────────────
; Holdings Summary
; ───────────────────────────────────────────────────────────────────────────────
{.holdings}
total_digital_assets = #$.18:(0..)        ; Total value of all digital assets
cryptocurrency_value = #$.18:(0..)        ; Total value of cryptocurrencies
token_value = #$.18:(0..)                 ; Total value of tokens
nft_value = #$.18:(0..)                   ; Total value of NFTs
defi_position_value = #$.18:(0..)         ; Total value of DeFi positions
stablecoin_value = #$.18:(0..)            ; Total value of stablecoins

{@crypto_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Storage Distribution
; ───────────────────────────────────────────────────────────────────────────────
{.storage}
hot_wallet_percentage = ##:(0..100)
cold_storage_percentage = ##:(0..100)
custodian_held_percentage = ##:(0..100)
exchange_held_percentage = ##:(0..100)
defi_deployed_percentage = ##:(0..100)
:invariant hot_wallet_percentage + cold_storage_percentage + custodian_held_percentage + exchange_held_percentage + defi_deployed_percentage <= 100

{@crypto_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Blockchain Concentration
; ───────────────────────────────────────────────────────────────────────────────
{.blockchain_concentration[]}
blockchain = (
    arbitrum,
    avalanche,
    base,
    binance_smart_chain,
    bitcoin,
    cardano,
    ethereum,
    optimism,
    polygon,
    solana,
    other
)
percentage = ##:(0..100)                  ; Percentage of holdings on this blockchain
value = #$.18:(0..)                       ; Value of holdings on this blockchain

{@crypto_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Custodian Concentration
; ───────────────────────────────────────────────────────────────────────────────
{.custodian_concentration[]}
custodian_name = :                        ; Name of the custodian
percentage = ##:(0..100)                  ; Percentage of holdings with this custodian
value = #$.18:(0..)                       ; Value of holdings with this custodian

{@crypto_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Transaction Volume
; ───────────────────────────────────────────────────────────────────────────────
{.transaction_volume}
daily_average = #$.18:(0..)               ; Average daily transaction volume
monthly_volume = #$.18:(0..)              ; Monthly transaction volume
largest_single_transaction = #$.18:(0..)  ; Largest single transaction amount

{@crypto_exposure}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@crypto_claims_history}
history_id = :                            ; Unique identifier for claims history

; Prior Claims
total_claims_5_years = ##                 ; Total number of claims in past 5 years
total_incurred_5_years = #$:(0..)         ; Total incurred amount in past 5 years

{.claims[]}
claim_number = :                          ; Claim number
date_discovered = date                    ; Date claim was discovered
date_reported = date                      ; Date claim was reported
claim_type = (
    bridge_exploit,
    custodian_failure,
    defi_exploit,
    hack_external,
    hack_insider,
    key_loss,
    nft_theft,
    oracle_manipulation,
    phishing,
    ransomware,
    regulatory_action,
    sim_swap,
    smart_contract_exploit,
    social_engineering,
    stablecoin_depeg,
    other
)
assets_affected[] = :                     ; Asset names/symbols
blockchain = :                            ; Blockchain where incident occurred
amount_lost = #$.18:(0..)                 ; Amount lost in incident
amount_recovered = #$.18:(0..)            ; Amount recovered
status = (closed_no_payment, closed_paid, open)  ; Claim status
paid_amount = #$.18:(0..)                 ; Amount paid on claim
reserves = #$.18:(0..)                    ; Amount reserved for claim

; Blockchain Forensics
{.forensics}
transaction_hash = :                      ; Transaction hash of incident
wallet_addresses_involved[] = :           ; Wallet addresses involved in incident
blockchain_analytics_used = ?             ; Whether blockchain analytics were used
funds_traced = ?                          ; Whether funds were traced
law_enforcement_involved = ?              ; Whether law enforcement was involved

{@crypto_claims_history}

; ───────────────────────────────────────────────────────────────────────────────
; Prior Incidents (unreported or under retention)
; ───────────────────────────────────────────────────────────────────────────────
{.prior_incidents}
attempted_hacks = ##                      ; Number of attempted hacks
phishing_attempts = ##                    ; Number of phishing attempts
near_misses = ##                          ; Number of near-miss incidents

{@crypto_claims_history}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Claim
; ═══════════════════════════════════════════════════════════════════════════════
; Individual claim structure with blockchain-specific details

{@crypto_claim}
id = :                                    ; Unique identifier for the claim
number = :                                ; Claim number

; ───────────────────────────────────────────────────────────────────────────────
; Claim Basics
; ───────────────────────────────────────────────────────────────────────────────
date_of_loss = date                       ; Date the loss occurred
date_discovered = date                    ; Date the loss was discovered
date_reported = date                      ; Date the loss was reported
:invariant date_discovered >= date_of_loss
:invariant date_reported >= date_discovered

status = (
    closed_denied,
    closed_paid,
    closed_withdrawn,
    litigation,
    open_investigation,
    open_payment_pending,
    subrogation
)

type = (
    bridge_exploit,
    custodian_failure,
    defi_exploit,
    hack_external,
    hack_insider,
    key_loss,
    nft_theft,
    oracle_manipulation,
    phishing,
    ransomware,
    regulatory_action,
    sim_swap,
    smart_contract_exploit,
    social_engineering,
    specie_loss,
    stablecoin_depeg,
    other
)

description = :                           ; Detailed description of the claim

; ───────────────────────────────────────────────────────────────────────────────
; Assets Involved
; ───────────────────────────────────────────────────────────────────────────────
{.assets[]}
asset = @digital_asset                    ; Reference to digital asset
quantity_lost = #                         ; Quantity of asset lost
value_at_loss = #$.18:(0..)               ; Value at time of loss
value_at_claim = #$.18:(0..)              ; Value at time of claim
quantity_recovered = #                    ; Quantity recovered
value_recovered = #$.18:(0..)             ; Value of recovered assets

{@crypto_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Blockchain Transaction Details
; ───────────────────────────────────────────────────────────────────────────────
{.blockchain_details}
blockchain = (
    arbitrum,
    avalanche,
    base,
    binance_smart_chain,
    bitcoin,
    cardano,
    ethereum,
    optimism,
    polygon,
    solana,
    other
)
transaction_hashes[] = :                  ; Transaction hashes involved
block_numbers[] = ##                      ; Block numbers involved
victim_addresses[] = :                    ; Victim wallet addresses
attacker_addresses[] = :                  ; Attacker wallet addresses
contract_addresses[] = :                  ; Smart contract addresses involved

{@crypto_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Attack Vector Details
; ───────────────────────────────────────────────────────────────────────────────
{.attack_vector}
attack_type = (
    access_control_exploit,
    address_poisoning,
    approval_phishing,
    dns_hijack,
    flash_loan,
    front_running,
    governance_attack,
    insider_compromise,
    oracle_manipulation,
    phishing_email,
    phishing_website,
    private_key_compromise,
    reentrancy,
    sandwich_attack,
    sim_swap,
    social_engineering,
    zero_day_exploit,
    other
)
attack_description = :                    ; Description of the attack
vulnerability_identified = :              ; Vulnerability that was exploited
cve_id = :                                ; If applicable

{@crypto_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Investigation
; ───────────────────────────────────────────────────────────────────────────────
{.investigation}
forensic_firm = :                         ; Forensic investigation firm
blockchain_analytics_firm = :             ; Blockchain analytics firm used
law_enforcement_agency = :                ; Law enforcement agency involved
law_enforcement_case_number = :           ; Law enforcement case number
civil_litigation_filed = ?                ; Whether civil litigation was filed
criminal_charges_filed = ?                ; Whether criminal charges were filed

; Fund Tracing
funds_traced = ?                          ; Whether funds were traced
traced_to_exchange = ?:if investigation.funds_traced = true  ; Whether funds were traced to an exchange
exchange_name = ::if investigation.traced_to_exchange = true  ; Name of exchange where funds traced
freeze_request_submitted = ?:if investigation.traced_to_exchange = true  ; Whether freeze request was submitted
freeze_successful = ?:if investigation.freeze_request_submitted = true  ; Whether freeze was successful
mixer_tornado_used = ?:if investigation.funds_traced = true  ; Whether mixer/tornado was used
cross_chain_transfer = ?:if investigation.funds_traced = true  ; Whether cross-chain transfer occurred

{@crypto_claim}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Summary
; ───────────────────────────────────────────────────────────────────────────────
{.financials}
total_loss = #$.18:(0..)                  ; Total amount of loss
retention_applied = #$:(0..)              ; Retention/deductible applied
coinsurance_applied = #$:(0..)            ; Coinsurance amount applied
sublimit_applied = #$:(0..)               ; Sublimit applied
amount_payable = #$:(0..)                 ; Total amount payable on claim
paid_to_date = #$:(0..)                   ; Amount paid to date
outstanding_reserves = #$:(0..)           ; Outstanding reserves
subrogation_potential = #$:(0..)          ; Potential subrogation recovery
subrogation_recovered = #$:(0..)          ; Amount recovered through subrogation

{@crypto_claim}

; ═══════════════════════════════════════════════════════════════════════════════
; Crypto Policy
; ═══════════════════════════════════════════════════════════════════════════════
; Main policy wrapper composing all parts

{@crypto_policy}
id = :                                    ; Unique identifier for the policy
number = :                                ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                     ; Policy effective date
effective_time = time                     ; Policy effective time
expiration_date = date                    ; Policy expiration date
expiration_time = time                    ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    crime_only,                   ; Crime/theft only
    custody_only,                 ; Custodian E&O
    cyber_endorsement,            ; Add-on to cyber policy
    excess,                       ; Excess layer
    full_program,                 ; Comprehensive coverage
    nft_only,                     ; NFT-specific
    standalone                    ; Standalone digital asset policy
)

policy_form = (
    claims_made,                  ; Claims-made basis
    occurrence                    ; Occurrence basis (rare)
)

; Claims-Made Dates
retroactive_date = date:if policy_form = claims_made  ; Retroactive coverage date
continuity_date = date:if policy_form = claims_made  ; Prior acts continuity date

; Extended Reporting Period
erp_purchased = ?                         ; Whether extended reporting period was purchased
erp_months = ##:if erp_purchased = true   ; Duration of ERP in months

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business          ; Reference to named insured business entity

; Insured Entity Type
insured_type = (
    crypto_exchange,
    crypto_fund,
    custodian,
    dao,
    defi_protocol,
    institutional_holder,
    mining_operation,
    nft_marketplace,
    payment_processor,
    retail_holder,
    staking_service,
    technology_provider,
    wallet_provider
)

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @crypto_coverage               ; Coverage structure reference

; ───────────────────────────────────────────────────────────────────────────────
; Exposure
; ───────────────────────────────────────────────────────────────────────────────
exposure = @crypto_exposure               ; Exposure profile reference

; ───────────────────────────────────────────────────────────────────────────────
; Security Controls
; ───────────────────────────────────────────────────────────────────────────────
security_controls = @crypto_security_controls  ; Security controls reference

; ───────────────────────────────────────────────────────────────────────────────
; Wallets
; ───────────────────────────────────────────────────────────────────────────────
wallets[] = @crypto_wallet                ; List of crypto wallets

; ───────────────────────────────────────────────────────────────────────────────
; Custodians
; ───────────────────────────────────────────────────────────────────────────────
custodians[] = @crypto_custodian          ; List of custodians

; ───────────────────────────────────────────────────────────────────────────────
; Digital Assets (Scheduled)
; ───────────────────────────────────────────────────────────────────────────────
scheduled_assets[] = @digital_asset       ; List of scheduled digital assets

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims_history = @crypto_claims_history   ; Claims history reference

; ───────────────────────────────────────────────────────────────────────────────
; Approved Service Providers
; ───────────────────────────────────────────────────────────────────────────────
{.service_providers}
forensics_firms[] = :                     ; List of approved forensics firms
blockchain_analytics[] = :                ; List of approved blockchain analytics providers
legal_counsel[] = :                       ; List of approved legal counsel
incident_response[] = :                   ; List of approved incident response providers

{@crypto_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation Methodology
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
methodology = (
    agreed_value,                 ; Pre-agreed scheduled values
    average_price,                ; Multiple exchange average
    cost_basis,                   ; Original acquisition cost
    exchange_rate,                ; Specific exchange price
    market_value                  ; Fair market value at loss
)
valuation_timing = (
    date_of_discovery,
    date_of_loss,
    date_of_payment,
    date_of_report
)
primary_exchange = ::if valuation.methodology = exchange_rate  ; Primary exchange for valuation
backup_exchanges[] = ::if valuation.methodology = exchange_rate  ; Backup exchanges for valuation
price_oracle = :                          ; Chainlink, etc.

{@crypto_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Warranties and Conditions
; ───────────────────────────────────────────────────────────────────────────────
{.warranties}
mfa_required = ?                          ; Whether MFA is required as warranty
cold_storage_minimum_percentage = ##:(0..100)  ; Minimum percentage required in cold storage
multi_sig_required = ?                    ; Whether multi-signature is required
multi_sig_threshold = ##:if warranties.multi_sig_required = true  ; Required multi-sig threshold
soc2_custodian_required = ?               ; Whether SOC 2 certified custodian required
audit_required_for_defi = ?               ; Whether audit required for DeFi interactions
whitelisting_required = ?                 ; Whether address whitelisting required
maximum_hot_wallet_percentage = ##:(0..100)  ; Maximum percentage allowed in hot wallets
maximum_single_custodian_percentage = ##:(0..100)  ; Maximum percentage with single custodian
security_review_frequency = (annual, quarterly, semi_annual)  ; Required security review frequency

{@crypto_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
; Standard Exclusions
war_terrorism = ?true
sanctions = ?true
government_seizure = ?true
market_fluctuation = ?true
voluntary_transfer = ?true
unaudited_protocols = ?
algorithmic_stablecoins = ?
meme_coins = ?
rug_pulls = ?                    ; Exit scams by token creators
known_vulnerabilities = ?
protocol_specific[] = :                   ; Specific excluded protocols/tokens

{@crypto_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$:(0..)                           ; Base premium amount
first_party = #$:(0..)                    ; First party coverage premium
third_party = #$:(0..)                    ; Third party coverage premium
nft_coverage = #$:(0..)                   ; NFT coverage premium
defi_coverage = #$:(0..)                  ; DeFi coverage premium
endorsements = #$:(0..)                   ; Endorsement premium
taxes_fees = #$:(0..)                     ; Taxes and fees
total = #$:(0..)                          ; Total premium
minimum = #$:(0..)                        ; Minimum earned premium
rate_on_line = #                          ; Premium / Limit ratio

{@crypto_policy}


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Cyber Liability Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Cyber liability coverage for data breach response, network security business
; interruption, ransomware/cyber extortion, privacy liability, media liability,
; and regulatory defense under GDPR, CCPA, HIPAA, and PCI-DSS frameworks.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.specialty.cyber-liability"
version = "1.0.0"
title = "Cyber Liability Insurance Schema"
description = "Comprehensive cyber coverage for data breach, network security, and privacy"

{$derivation}
source[0].authority = "National Institute of Standards and Technology"
source[0].citation = "NIST Cybersecurity Framework 2.0"
source[0].url = "https://www.nist.gov/cyberframework"

source[1].authority = "European Union"
source[1].citation = "General Data Protection Regulation (GDPR)"
source[1].url = "https://gdpr.eu/"

source[2].authority = "California Attorney General"
source[2].citation = "California Consumer Privacy Act / CPRA"
source[2].url = "https://oag.ca.gov/privacy/ccpa"

source[3].authority = "U.S. Department of Health and Human Services"
source[3].citation = "HIPAA Privacy and Security Rules"
source[3].url = "https://www.hhs.gov/hipaa/"

source[4].authority = "Payment Card Industry Security Standards Council"
source[4].citation = "PCI Data Security Standard"
source[4].url = "https://www.pcisecuritystandards.org/"

methodology = "regulatory_derivation"           ; Derivation methodology used
proprietary_sources_consulted = ?false        ; Whether proprietary sources were consulted
notes = "Complete cyber schema covering all first and third party cyber exposures" ; Additional notes

changelog[0].date = 2025-12-13                  ; Date of change
changelog[0].change = "Initial cyber liability schema" ; Description of change
changelog[0].rationale = "Comprehensive cyber risk coverage structure" ; Rationale for change

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Exposure Profile
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_exposure}
exposure_id = :                                ; Unique identifier for exposure profile

; ───────────────────────────────────────────────────────────────────────────────
; Data Holdings
; ───────────────────────────────────────────────────────────────────────────────

{.data}
; Personally Identifiable Information (PII)
pii_records = ##          ; Number of PII records
pii_types[] = (
    addresses,
    biometric_data,
    dates_of_birth,
    device_identifiers,
    drivers_license_numbers,
    email_addresses,
    geolocation_data,
    ip_addresses,
    names,
    national_id_numbers,
    other,
    passport_numbers,
    phone_numbers,
    social_security_numbers
)

; Protected Health Information (PHI)
phi_records = ##                              ; Number of PHI records under HIPAA
hipaa_covered_entity = ?                      ; Whether entity is HIPAA covered entity
hipaa_business_associate = ?                  ; Whether entity is HIPAA business associate
healthcare_provider = ?                       ; Whether entity is a healthcare provider

; Payment Card Data (PCI)
pci_transactions_annual = ##                  ; Annual payment card transactions processed
pci_records_stored = ##                       ; Number of payment card records stored
pci_level = (level_1, level_2, level_3, level_4) ; PCI-DSS compliance level based on volume
pci_compliant = ?                             ; Whether currently PCI-DSS compliant
pci_last_assessment_date = date               ; Date of last PCI compliance assessment
payment_processor = :                         ; Name of payment processor used

; Financial Data
financial_account_numbers = ##                ; Number of financial account numbers stored
glba_subject = ?                              ; Whether subject to Gramm-Leach-Bliley Act

; Employee Data
employee_records = ##                         ; Number of employee records maintained
employee_ssn_stored = ?                       ; Whether employee SSNs are stored

; Intellectual Property
trade_secrets = ?                             ; Whether trade secrets are stored electronically
source_code = ?                               ; Whether proprietary source code is stored
customer_lists = ?                            ; Whether customer lists are stored electronically

{@cyber_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Scope
; ───────────────────────────────────────────────────────────────────────────────

{.geography}
us_data_subjects = ##                         ; Number of US data subjects
eu_data_subjects = ##                         ; Number of EU data subjects (GDPR)
uk_data_subjects = ##                         ; Number of UK data subjects (UK GDPR)
california_data_subjects = ##                 ; Number of California data subjects (CCPA/CPRA)
other_jurisdictions[] = :                     ; Other jurisdictions with data subjects

{@cyber_exposure}

; ───────────────────────────────────────────────────────────────────────────────
; Revenue Concentration
; ───────────────────────────────────────────────────────────────────────────────

{.revenue}
technology_dependent_percentage = ##:(0..100) ; Percentage of revenue dependent on technology
e_commerce_percentage = ##:(0..100)           ; Percentage of revenue from e-commerce
from_data_processing = #$                     ; Annual revenue from data processing services

{@cyber_exposure}

; ═══════════════════════════════════════════════════════════════════════════════
; IT Infrastructure
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_infrastructure}
infra_id = :                                  ; Unique identifier for infrastructure profile

; ───────────────────────────────────────────────────────────────────────────────
; Network Architecture
; ───────────────────────────────────────────────────────────────────────────────

{.network}
endpoints = ##                                ; Number of network endpoints (workstations, laptops)
servers_physical = ##                         ; Number of physical servers
servers_virtual = ##                          ; Number of virtual servers
cloud_instances = ##                          ; Number of cloud compute instances
iot_devices = ##                              ; Number of IoT devices on network
remote_workforce_percentage = ##:(0..100)     ; Percentage of workforce working remotely
byod_policy = ?                               ; Whether bring-your-own-device policy exists

{@cyber_infrastructure}

; Cloud Usage
{.cloud}
providers[] = (aws, azure, gcp, ibm, oracle, other, salesforce) ; Cloud service providers used
iaas = ?                                      ; Whether using Infrastructure as a Service
paas = ?                                      ; Whether using Platform as a Service
saas = ?                                      ; Whether using Software as a Service
hybrid = ?                                    ; Whether using hybrid cloud architecture
multi_cloud = ?                               ; Whether using multiple cloud providers
percentage_workloads = ##:(0..100)            ; Percentage of workloads in cloud

{@cyber_infrastructure}

; ───────────────────────────────────────────────────────────────────────────────
; Website / E-Commerce
; ───────────────────────────────────────────────────────────────────────────────

{.website}
annual_visitors = ##                          ; Annual website visitors
user_accounts = ##                            ; Number of registered user accounts
e_commerce = ?                                ; Whether website has e-commerce functionality
mobile_app = ?                                ; Whether mobile app exists
payment_processing = ?                        ; Whether payment processing is integrated
third_party_integrations = ##                 ; Number of third-party integrations

{@cyber_infrastructure}

; ───────────────────────────────────────────────────────────────────────────────
; Operational Technology (OT) / Industrial Control Systems
; ───────────────────────────────────────────────────────────────────────────────

{.ot}
industrial_control_systems = ?                ; Whether ICS/SCADA systems are used
scada_systems = ?                             ; Whether SCADA systems are used
manufacturing_systems = ?                     ; Whether manufacturing systems are networked
building_automation = ?                       ; Whether building automation systems exist
medical_devices = ?                           ; Whether medical devices are networked
connected_vehicles = ?                        ; Whether connected vehicles are used
air_gapped = ?:if ot.industrial_control_systems = true ; Whether OT systems are air-gapped

{@cyber_infrastructure}

; ═══════════════════════════════════════════════════════════════════════════════
; Security Controls
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_security_controls}
controls_id = :                               ; Unique identifier for security controls profile

; ───────────────────────────────────────────────────────────────────────────────
; Access Controls
; ───────────────────────────────────────────────────────────────────────────────

{.access}
mfa_enabled = ?                               ; Whether multi-factor authentication is enabled
mfa_percentage = ##:(0..100)                  ; Percentage of users with MFA enabled
mfa_remote_access = ?                         ; Whether MFA required for remote access
mfa_privileged_accounts = ?                   ; Whether MFA required for privileged accounts
mfa_email = *?                                ; Whether MFA required for email access
password_policy = ?                           ; Whether formal password policy exists
password_min_length = ##                      ; Minimum password length required
privileged_access_management = ?              ; Whether PAM solution is implemented
least_privilege_principle = ?                 ; Whether least privilege principle is enforced
zero_trust_architecture = ?                   ; Whether zero trust architecture is implemented

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Network Security
; ───────────────────────────────────────────────────────────────────────────────

{.network_security}
firewall = ?                                  ; Whether firewall is deployed
next_gen_firewall = ?                         ; Whether next-generation firewall is used
intrusion_detection = ?                       ; Whether IDS is deployed
intrusion_prevention = ?                      ; Whether IPS is deployed
network_segmentation = ?                      ; Whether network segmentation is implemented
dmz = ?                                       ; Whether DMZ exists for public-facing services
vpn_remote_access = ?                         ; Whether VPN is required for remote access
web_application_firewall = ?                  ; Whether WAF is deployed
ddos_protection = ?                           ; Whether DDoS protection is in place

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Endpoint Security
; ───────────────────────────────────────────────────────────────────────────────

{.endpoint}
antivirus = ?                                 ; Whether antivirus is deployed
edr = ?                                       ; Endpoint Detection & Response
xdr = ?                                       ; Extended Detection & Response
mdm = ?                                       ; Mobile Device Management
encryption_full_disk = ?                      ; Whether full disk encryption is enabled
encryption_percentage = ##:(0..100)           ; Percentage of endpoints with encryption
patch_management = ?                          ; Whether patch management system is used
patch_cadence = (immediate, monthly, quarterly, weekly) ; Frequency of patch deployment

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Email Security
; ───────────────────────────────────────────────────────────────────────────────

{.email}
spam_filter = ?                               ; Whether spam filtering is enabled
malware_scanning = ?                          ; Whether email malware scanning is enabled
phishing_protection = ?                       ; Whether anti-phishing protection is enabled
dmarc_enabled = ?                             ; Whether DMARC is configured
email_encryption = ?                          ; Whether email encryption is available
dlp = ?                                       ; Data Loss Prevention

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Backup and Recovery
; ───────────────────────────────────────────────────────────────────────────────

{.backup}
regular_backups = ?                           ; Whether regular backups are performed
frequency = (continuous, daily, monthly, weekly) ; Frequency of backups
offsite_copies = ?                            ; Whether offsite backup copies exist
air_gapped_copies = ?                         ; Whether air-gapped backup copies exist
encryption = ?                                ; Whether backups are encrypted
tested = ?                                    ; Whether backups are regularly tested
test_frequency = (annually, monthly, quarterly) ; Frequency of backup testing
rto_hours = ##:(0..8760)                      ; Recovery Time Objective
rpo_hours = ##:(0..8760)                      ; Recovery Point Objective

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Security Operations
; ───────────────────────────────────────────────────────────────────────────────

{.security_ops}
siem = ?                                      ; Security Information & Event Management
soc = ?                                       ; Security Operations Center
soc_type = (hybrid, internal, outsourced):if security_ops.soc = true ; Type of SOC deployment
soc_24x7 = ?:if security_ops.soc = true       ; Whether SOC operates 24x7
threat_intelligence = ?                       ; Whether threat intelligence feeds are used
vulnerability_scanning = ?                    ; Whether vulnerability scanning is performed
vulnerability_scan_frequency = (continuous, monthly, quarterly, weekly) ; Frequency of vulnerability scans
penetration_testing = ?                       ; Whether penetration testing is performed
pen_test_frequency = (annual, quarterly, semi_annual) ; Frequency of penetration testing

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Incident Response
; ───────────────────────────────────────────────────────────────────────────────

{.incident_response}
written_plan = ?                              ; Whether written incident response plan exists
plan_tested = ?                               ; Whether plan has been tested
tabletop_exercises = ?                        ; Whether tabletop exercises are conducted
retainer_vendor = ?                           ; Whether IR vendor on retainer
retainer_vendor_name = ::if incident_response.retainer_vendor = true ; Name of IR vendor on retainer

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Training
; ───────────────────────────────────────────────────────────────────────────────

{.training}
security_awareness = ?                        ; Whether security awareness training is provided
frequency = (annual, monthly, quarterly, semi_annual) ; Frequency of security awareness training
phishing_simulations = ?                      ; Whether phishing simulations are conducted
phishing_simulation_frequency = (monthly, quarterly, semi_annual) ; Frequency of phishing simulations

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Third Party Risk
; ───────────────────────────────────────────────────────────────────────────────

{.third_party}
vendor_risk_management = ?                    ; Whether vendor risk management program exists
vendor_security_assessments = ?               ; Whether vendor security assessments are conducted
critical_vendors_identified = ?               ; Whether critical vendors have been identified
msp_used = ?                                  ; Managed Service Provider
msp_with_admin_access = ?:if third_party.msp_used = true ; Whether MSP has admin access to systems

{@cyber_security_controls}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance / Certifications
; ───────────────────────────────────────────────────────────────────────────────

{.certifications}
soc2_type1 = ?                                ; Whether SOC 2 Type I certified
soc2_type2 = ?                                ; Whether SOC 2 Type II certified
iso_27001 = ?                                 ; Whether ISO 27001 certified
pci_dss = ?                                   ; Whether PCI-DSS compliant
hipaa = ?                                     ; Whether HIPAA compliant
hitrust = ?                                   ; Whether HITRUST certified
fedramp = ?                                   ; Whether FedRAMP authorized
nist_csf = ?                                  ; Whether NIST CSF aligned
cis_controls = ?                              ; Whether CIS Controls implemented

{@cyber_security_controls}

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Coverage Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_coverage}
coverage_id = :                              ; Unique identifier for coverage
policy_aggregate = #$                        ; Policy aggregate limit
retention_base = ##                           ; Base retention/deductible amount

; ═══════════════════════════════════════════════════════════════════════════════
; FIRST PARTY COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Data Breach / Incident Response
; ───────────────────────────────────────────────────────────────────────────────

{.breach_response}
included = ?true                              ; Whether breach response coverage is included
sublimit = #$:if breach_response.included = true ; Sublimit for breach response
retention = ##:if breach_response.included = true ; Retention for breach response

; Covered Expenses
forensic_investigation = ?:if breach_response.included = true ; Whether forensic investigation covered
legal_services = ?:if breach_response.included = true ; Whether legal services covered
notification_costs = ?:if breach_response.included = true ; Whether notification costs covered
credit_monitoring = ?:if breach_response.included = true ; Whether credit monitoring covered
credit_monitoring_months = ##:(12, 24, 36):if breach_response.credit_monitoring = true ; Duration of credit monitoring
identity_restoration = ?:if breach_response.included = true ; Whether identity restoration covered
call_center = ?:if breach_response.included = true ; Whether call center services covered
public_relations = ?:if breach_response.included = true ; Whether PR services covered
crisis_management = ?:if breach_response.included = true ; Whether crisis management covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Business Interruption / System Failure
; ───────────────────────────────────────────────────────────────────────────────

{.business_interruption}
included = ?                                  ; Whether business interruption coverage included
sublimit = #$:if business_interruption.included = true ; Sublimit for business interruption
retention = ##:if business_interruption.included = true ; Retention for business interruption
waiting_period_hours = ##:(0, 6, 8, 12, 24, 48, 72):if business_interruption.included = true ; Waiting period before coverage applies
period_of_restoration_days = ##:(30, 60, 90, 120, 180, 365):if business_interruption.included = true ; Maximum period of restoration

; Triggers
security_failure = ?:if business_interruption.included = true ; Whether security failure triggers coverage
system_failure = ?:if business_interruption.included = true ; Whether system failure triggers coverage
dependent_business = ?:if business_interruption.included = true ; Whether dependent business triggers coverage
cloud_provider_outage = ?:if business_interruption.included = true ; Whether cloud outage triggers coverage
utility_failure = ?:if business_interruption.included = true ; Whether utility failure triggers coverage

; Coverage
lost_income = ?:if business_interruption.included = true ; Whether lost income is covered
extra_expense = ?:if business_interruption.included = true ; Whether extra expense is covered
contingent_bi = ?:if business_interruption.included = true ; Whether contingent BI is covered
contingent_bi_sublimit = #$:if business_interruption.contingent_bi = true ; Sublimit for contingent BI
forensic_accounting = ?:if business_interruption.included = true ; Whether forensic accounting is covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cyber Extortion / Ransomware
; ───────────────────────────────────────────────────────────────────────────────

{.extortion}
included = ?                                  ; Whether cyber extortion coverage is included
sublimit = #$:if extortion.included = true    ; Sublimit for cyber extortion
retention = ##:if extortion.included = true   ; Retention for cyber extortion
coinsurance = ##:(0..50):if extortion.included = true ; Coinsurance percentage for ransom payment

; Covered Expenses
ransom_payment = ?:if extortion.included = true ; Whether ransom payment is covered
negotiation_costs = ?:if extortion.included = true ; Whether negotiation costs are covered
cryptocurrency_fluctuation = ?:if extortion.included = true ; Whether cryptocurrency fluctuation covered
forensics = ?:if extortion.included = true    ; Whether forensic investigation is covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Data Restoration
; ───────────────────────────────────────────────────────────────────────────────

{.data_restoration}
included = ?                                  ; Whether data restoration coverage is included
sublimit = #$:if data_restoration.included = true ; Sublimit for data restoration
retention = ##:if data_restoration.included = true ; Retention for data restoration
data = ?:if data_restoration.included = true  ; Whether data restoration is covered
software = ?:if data_restoration.included = true ; Whether software restoration is covered
systems = ?:if data_restoration.included = true ; Whether system restoration is covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Reputational Harm
; ───────────────────────────────────────────────────────────────────────────────

{.reputational}
included = ?                                  ; Whether reputational harm coverage is included
sublimit = #$:if reputational.included = true ; Sublimit for reputational harm
retention = ##:if reputational.included = true ; Retention for reputational harm

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Bricking / Hardware Replacement
; ───────────────────────────────────────────────────────────────────────────────

{.bricking}
included = ?                                  ; Whether bricking/hardware replacement is covered
sublimit = #$:if bricking.included = true     ; Sublimit for bricking coverage
retention = ##:if bricking.included = true    ; Retention for bricking coverage

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Social Engineering / Funds Transfer Fraud
; ───────────────────────────────────────────────────────────────────────────────

{.social_engineering}
included = ?                                  ; Whether social engineering coverage is included
sublimit = #$:if social_engineering.included = true ; Sublimit for social engineering
retention = ##:if social_engineering.included = true ; Retention for social engineering
vendor_impersonation = ?:if social_engineering.included = true ; Whether vendor impersonation is covered
executive_impersonation = ?:if social_engineering.included = true ; Whether executive impersonation is covered
invoice_manipulation = ?:if social_engineering.included = true ; Whether invoice manipulation is covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Cryptojacking
; ───────────────────────────────────────────────────────────────────────────────

{.cryptojacking}
included = ?                                  ; Whether cryptojacking coverage is included
sublimit = #$:if cryptojacking.included = true ; Sublimit for cryptojacking coverage

{@cyber_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; THIRD PARTY COVERAGES
; ═══════════════════════════════════════════════════════════════════════════════

; ───────────────────────────────────────────────────────────────────────────────
; Network Security Liability
; ───────────────────────────────────────────────────────────────────────────────

{.network_security_liability}
included = ?true                              ; Whether network security liability is included
sublimit = #$:if network_security_liability.included = true ; Sublimit for network security liability
retention = ##:if network_security_liability.included = true ; Retention for network security liability

; Covered Claims
unauthorized_access = ?:if network_security_liability.included = true ; Whether unauthorized access claims covered
denial_of_service = ?:if network_security_liability.included = true ; Whether denial of service claims covered
malware_transmission = ?:if network_security_liability.included = true ; Whether malware transmission claims covered
failure_to_prevent = ?:if network_security_liability.included = true ; Whether failure to prevent claims covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Privacy Liability
; ───────────────────────────────────────────────────────────────────────────────

{.privacy_liability}
included = ?true                              ; Whether privacy liability is included
sublimit = #$:if privacy_liability.included = true ; Sublimit for privacy liability
retention = ##:if privacy_liability.included = true ; Retention for privacy liability

; Covered Claims
breach_of_privacy = ?:if privacy_liability.included = true ; Whether breach of privacy claims covered
wrongful_collection = ?:if privacy_liability.included = true ; Whether wrongful collection claims covered
failure_to_protect = ?:if privacy_liability.included = true ; Whether failure to protect claims covered
employee_privacy = ?:if privacy_liability.included = true ; Whether employee privacy claims covered
biometric_data = ?:if privacy_liability.included = true ; Whether biometric data claims covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Regulatory Defense and Penalties
; ───────────────────────────────────────────────────────────────────────────────

{.regulatory}
included = ?                                  ; Whether regulatory defense coverage is included
sublimit = #$:if regulatory.included = true   ; Sublimit for regulatory defense
retention = ##:if regulatory.included = true  ; Retention for regulatory defense

; Covered Regulators
ftc = ?:if regulatory.included = true         ; Whether FTC proceedings are covered
sec = ?:if regulatory.included = true         ; Whether SEC proceedings are covered
hhs_ocr = ?:if regulatory.included = true     ; HIPAA
state_ag = ?:if regulatory.included = true    ; Whether state AG proceedings are covered
gdpr_dpa = ?:if regulatory.included = true    ; Whether GDPR DPA proceedings are covered
other_international = ?:if regulatory.included = true ; Whether other international regulators covered

; Defense and Penalties
defense_costs = ?:if regulatory.included = true ; Whether defense costs are covered
civil_fines_penalties = ?:if regulatory.included = true ; Whether civil fines and penalties are covered
gdpr_fines = ?:if regulatory.included = true  ; Whether GDPR fines are covered
ccpa_penalties = ?:if regulatory.included = true ; Whether CCPA penalties are covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; PCI-DSS Assessment / Fines
; ───────────────────────────────────────────────────────────────────────────────

{.pci}
included = ?                                  ; Whether PCI-DSS assessment coverage is included
sublimit = #$:if pci.included = true          ; Sublimit for PCI coverage
retention = ##:if pci.included = true         ; Retention for PCI coverage
card_brand_fines = ?:if pci.included = true   ; Whether card brand fines are covered
forensic_investigation = ?:if pci.included = true ; Whether PCI forensic investigation is covered
fraud_reimbursement = ?:if pci.included = true ; Whether fraud reimbursement is covered
card_reissuance = ?:if pci.included = true    ; Whether card reissuance costs are covered

{@cyber_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Media Liability
; ───────────────────────────────────────────────────────────────────────────────

{.media_liability}
included = ?                                  ; Whether media liability is included
sublimit = #$:if media_liability.included = true ; Sublimit for media liability
retention = ##:if media_liability.included = true ; Retention for media liability

; Covered Claims
defamation = ?:if media_liability.included = true ; Whether defamation claims are covered
copyright_infringement = ?:if media_liability.included = true ; Whether copyright infringement claims covered
trademark_infringement = ?:if media_liability.included = true ; Whether trademark infringement claims covered
plagiarism = ?:if media_liability.included = true ; Whether plagiarism claims are covered
invasion_of_privacy = ?:if media_liability.included = true ; Whether invasion of privacy claims covered

{@cyber_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Claims History
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_claims_history}
history_id = :                                ; Unique identifier for claims history

; Prior Claims
total_claims_5_years = ##                     ; Total number of claims in past 5 years
total_incurred_5_years = #$                   ; Total incurred losses in past 5 years

{.claims[]}
claim_number = :                              ; Claim number
date_discovered = date                        ; Date incident was discovered
date_reported = date                          ; Date claim was reported to insurer
claim_type = (                                ; Type of cyber claim
    business_interruption,
    data_breach,
    other,
    pci_assessment,
    privacy_claim,
    ransomware,
    regulatory_action,
    social_engineering
)
records_affected = ##                         ; Number of records affected
status = (closed_no_payment, closed_paid, open) ; Current claim status
paid_first_party = #$                         ; Amount paid for first party costs
paid_third_party = #$                         ; Amount paid for third party liability
reserves = #$                                 ; Current reserves for the claim

{@cyber_claims_history}

; Prior Incidents (unreported or under retention)
{.prior_incidents}
ransomware_attacks = ##                       ; Number of ransomware attacks in past 5 years
data_breaches = ##                            ; Number of data breaches in past 5 years
business_email_compromise = ##                ; Number of BEC incidents in past 5 years
ddos_attacks = ##                             ; Number of DDoS attacks in past 5 years

{@cyber_claims_history}

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Endorsements
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_endorsement}
id = :                                       ; Unique identifier for endorsement
number = :                                   ; Endorsement number
title = :                                     ; Endorsement title
effective_date = date                         ; Effective date of endorsement

; Endorsement Type
type = (                                      ; Type of endorsement
    contingent_bi_extension,
    crypto_coverage,
    increased_limits,
    infrastructure_exclusion,
    other,
    ot_coverage,
    ransomware_coinsurance,
    reduced_retention,
    retroactive_date_change,
    social_engineering_extension,
    technology_services_extension,
    territory_extension,
    war_exclusion
)

description = :                               ; Description of endorsement
premium_impact = #$                           ; Premium impact of endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Cyber Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@cyber_policy}
id = :                                       ; Unique identifier for policy
number = :                                   ; Policy number
effective_date = date                        ; Policy effective date
expiration_date = date                       ; Policy expiration date
retroactive_date = date                      ; Retroactive date for claims-made coverage

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_time = time                         ; Policy effective time
expiration_time = time                        ; Policy expiration time
:invariant expiration_date > effective_date   ; Expiration must be after effective date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (                                      ; Type of cyber policy
    bop_endorsement,
    excess,
    management_liability,                     ; D&O/EPLI package
    standalone,
    tech_eo_cyber                             ; Combined with Tech E&O
)

; ───────────────────────────────────────────────────────────────────────────────
; Claims-Made Dates
; ───────────────────────────────────────────────────────────────────────────────
continuity_date = date                        ; Continuity date for prior acts coverage
pending_prior_date = date                     ; Pending and prior litigation date

; Extended Reporting Period
erp_purchased = ?                             ; Whether extended reporting period purchased
erp_type = (basic_60_days, supplemental_1_year, supplemental_3_year):if erp_purchased = true ; Type of ERP purchased
erp_effective_date = date:if erp_purchased = true ; Effective date of ERP

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business              ; Reference to named insured business entity

; ───────────────────────────────────────────────────────────────────────────────
; Coverage
; ───────────────────────────────────────────────────────────────────────────────
coverage = @cyber_coverage                    ; Reference to coverage structure

; ───────────────────────────────────────────────────────────────────────────────
; Exposure Profile
; ───────────────────────────────────────────────────────────────────────────────
exposure = @cyber_exposure                    ; Reference to cyber exposure profile

; ───────────────────────────────────────────────────────────────────────────────
; Infrastructure
; ───────────────────────────────────────────────────────────────────────────────
infrastructure = @cyber_infrastructure        ; Reference to IT infrastructure profile

; ───────────────────────────────────────────────────────────────────────────────
; Security Controls
; ───────────────────────────────────────────────────────────────────────────────
security_controls = @cyber_security_controls  ; Reference to security controls profile

; ───────────────────────────────────────────────────────────────────────────────
; Claims History
; ───────────────────────────────────────────────────────────────────────────────
claims_history = @cyber_claims_history        ; Reference to claims history

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @cyber_endorsement           ; Array of policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Panel Vendors (Carrier-Approved)
; ───────────────────────────────────────────────────────────────────────────────

{.panel}
breach_coach = :                              ; Approved breach coach vendor
forensics[] = :                               ; Approved forensic investigation vendors
legal[] = :                                   ; Approved legal counsel vendors
notification[] = :                            ; Approved notification service vendors
credit_monitoring[] = :                       ; Approved credit monitoring vendors
public_relations[] = :                        ; Approved public relations vendors
ransom_negotiator[] = :                       ; Approved ransom negotiation vendors

{@cyber_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────

{.premium}
base = #$                                     ; Base premium amount
first_party = #$                              ; Premium for first party coverages
third_party = #$                              ; Premium for third party coverages
endorsements = #$                             ; Premium for endorsements
taxes_fees = #$                               ; Taxes and fees
total = #$                                    ; Total premium
minimum = #$                                  ; Minimum earned premium

{@cyber_policy}



; ═══════════════════════════════════════════════════════════════════════════════
; ODIN eDiscovery Collection Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Electronic discovery collection following the EDRM framework from
; identification through preservation and collection. Covers custodian
; management, data source inventories, legal hold notices and
; acknowledgments, and forensic collection tracking.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.ediscovery.collection"
version = "1.0.0"
title = "eDiscovery Collection Schema"
description = "Custodian management and data collection for eDiscovery"

{$derivation}
source[0].authority = "Electronic Discovery Reference Model"
source[0].citation = "EDRM Framework - Identification, Preservation, Collection"
source[0].url = "https://edrm.net/frameworks-and-standards/edrm-model/"

source[1].authority = "Federal Rules of Civil Procedure"
source[1].citation = "Rule 26, Rule 34, Rule 37(e)"
source[1].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-civil-procedure"

source[2].authority = "The Sedona Conference"
source[2].citation = "The Sedona Principles, Third Edition"
source[2].url = "https://thesedonaconference.org/publication/The_Sedona_Principles"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Collection schema derived from EDRM framework and Sedona Principles"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial eDiscovery collection schema"
changelog[0].rationale = "EDRM-compliant collection tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY CUSTODIAN
; ═══════════════════════════════════════════════════════════════════════════════
; Person or entity with relevant data

{@ediscovery_custodian}
; Required fields first
custodian_name = :                               ; Custodian name
custodian_type = (contractor, department, employee, executive, former_employee, system, third_party)

; Custodian identification
custodian_id = :                                  ; Unique custodian ID
employee_id = :                                   ; Employee ID (if applicable)

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
case_ref = @legal_case_ref                        ; Reference to case

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Contact Information
; ───────────────────────────────────────────────────────────────────────────────
{.contact}
email = *@email                                   ; Primary email
phone = *@phone                                   ; Phone
address = @address                                ; Address
department = :                                    ; Department
title = :                                         ; Job title
manager = :                                       ; Manager name
manager_email = *@email                           ; Manager email

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Employment Status
; ───────────────────────────────────────────────────────────────────────────────
{.employment}
status = (active, former, leave, terminated)      ; Employment status
start_date = date                                 ; Employment start date
end_date = date:if status = former | status = terminated
last_working_day = date:if status = former | status = terminated
departure_type = (layoff, resignation, retirement, termination):if status = former | status = terminated

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Relevance
; ───────────────────────────────────────────────────────────────────────────────
{.relevance}
relevance_level = (high, low, medium, unknown)    ; Relevance to matter
relevance_description = :                         ; Why relevant
key_custodian = ?                                 ; Key/primary custodian
custodian_role = :                                ; Role in relevant events
time_period_start = date                          ; Relevant time period start
time_period_end = date                            ; Relevant time period end
topics[] = :                                      ; Relevant topics/issues

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Data Sources
; ───────────────────────────────────────────────────────────────────────────────
data_sources[] = @ediscovery_data_source          ; Custodian's data sources

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Legal Hold
; ───────────────────────────────────────────────────────────────────────────────
{.hold}
on_hold = ?                                       ; Currently on hold
hold_ref = @ediscovery_hold:if on_hold = true     ; Reference to hold
hold_notice_sent = ?                              ; Hold notice sent
hold_notice_date = date:if hold_notice_sent = true
hold_acknowledged = ?:if hold_notice_sent = true  ; Acknowledged hold
acknowledgment_date = date:if hold_acknowledged = true
reminder_count = ##:(0..)                         ; Reminders sent

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Interview
; ───────────────────────────────────────────────────────────────────────────────
{.interview}
interviewed = ?                                   ; Custodian interviewed
interview_date = date:if interviewed = true       ; Interview date
interviewed_by = ::if interviewed = true          ; Interviewer
interview_summary = ::if interviewed = true       ; Summary
data_sources_identified[] = ::if interviewed = true ; Sources identified

{@ediscovery_custodian}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Status
; ───────────────────────────────────────────────────────────────────────────────
{.collection}
collection_required = ?                           ; Collection needed
collection_complete = ?:if collection_required = true
collection_date = date:if collection_complete = true
collections[] = @ediscovery_collection            ; Collection references
total_data_collected_gb = #:(0..)                 ; Total GB collected
documents_collected = ##:(0..)                    ; Document count

{@ediscovery_custodian}

; Status
status = (active, collection_complete, collection_pending, identified, not_relevant, on_hold, released)
status_date = date                                ; Date of status

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY DATA SOURCE
; ═══════════════════════════════════════════════════════════════════════════════
; Data source for collection

{@ediscovery_data_source}
; Required fields first
source_name = :                                  ; Source name
source_type = (archive, backup, cloud_storage, database, desktop, email, file_share, instant_messaging, laptop, mobile, network_share, removable_media, server, social_media, voicemail)

; Source identification
source_id = :                                     ; Unique source ID

; ───────────────────────────────────────────────────────────────────────────────
; Source Details
; ───────────────────────────────────────────────────────────────────────────────
{.details}
platform = :                                      ; Platform (Exchange, Gmail, etc.)
location = :                                      ; Physical/logical location
hostname = :                                      ; Computer hostname
ip_address = :                                    ; IP address
cloud_provider = :                                ; Cloud provider name
account_id = :                                    ; Account identifier
path = :                                          ; File path or mailbox

{@ediscovery_data_source}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
custodian_ref = @ediscovery_custodian             ; Owning custodian
shared_source = ?                                 ; Shared data source
additional_custodians[] = :                       ; Other custodians with access
department_owner = :                              ; Department owner
it_contact = :                                    ; IT contact for source

{@ediscovery_data_source}

; ───────────────────────────────────────────────────────────────────────────────
; Data Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.metrics}
estimated_size_gb = #:(0..)                       ; Estimated size in GB
estimated_items = ##:(0..)                        ; Estimated item count
date_range_start = date                           ; Data date range start
date_range_end = date                             ; Data date range end
last_accessed = date                              ; Last access date
last_modified = date                              ; Last modification date

{@ediscovery_data_source}

; ───────────────────────────────────────────────────────────────────────────────
; Preservation
; ───────────────────────────────────────────────────────────────────────────────
{.preservation}
preservation_required = ?                         ; Preservation needed
preserved = ?:if preservation_required = true     ; Data preserved
preservation_method = (backup, collection, in_place_hold, snapshot):if preserved = true
preservation_date = date:if preserved = true      ; Date preserved
retention_policy_suspended = ?                    ; Retention suspended

{@ediscovery_data_source}

; ───────────────────────────────────────────────────────────────────────────────
; Collection
; ───────────────────────────────────────────────────────────────────────────────
{.collection}
collection_required = ?                           ; Collection needed
collected = ?:if collection_required = true       ; Data collected
collection_date = date:if collected = true        ; Collection date
collection_ref = @ediscovery_collection:if collected = true
collected_size_gb = #:(0..):if collected = true   ; Size collected
collected_items = ##:(0..):if collected = true    ; Items collected

{@ediscovery_data_source}

; Status
status = (active, collected, identified, not_accessible, not_relevant, preserved)

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY LEGAL HOLD
; ═══════════════════════════════════════════════════════════════════════════════
; Legal hold/litigation hold

{@ediscovery_hold}
; Required fields first
hold_name = :                                    ; Hold name/title
hold_type = (full, partial, targeted)            ; Hold type
initiated_date = date                            ; Hold initiation date

; Hold identification
hold_id = :                                       ; Unique hold ID

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
case_ref = @legal_case_ref                        ; Reference to case
triggering_event = :                              ; Event triggering hold
anticipated_litigation = ?                        ; Anticipation of litigation

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; Hold Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
scope_description = :                             ; Scope description
date_range_start = date                           ; Relevant date start
date_range_end = date                             ; Relevant date end
topics[] = :                                      ; Relevant topics
data_types[] = :                                  ; Data types to preserve
locations[] = :                                   ; Locations covered
keywords[] = :                                    ; Preservation keywords

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; Hold Notice
; ───────────────────────────────────────────────────────────────────────────────
{.notice}
notice_template = :                               ; Notice template used
notice_language = :                               ; Notice language summary
distribution_date = date                          ; Initial distribution date
distribution_method = (email, in_person, mail)    ; How distributed
reminder_frequency = (biweekly, monthly, quarterly, weekly)
last_reminder_date = date                         ; Last reminder sent

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; Custodians
; ───────────────────────────────────────────────────────────────────────────────
{.custodians[]}
custodian_ref = @ediscovery_custodian             ; Custodian reference
added_date = date                                 ; Date added to hold
notice_sent = ?                                   ; Notice sent
notice_date = date:if notice_sent = true          ; Notice date
acknowledged = ?:if notice_sent = true            ; Acknowledged
acknowledgment_date = date:if acknowledged = true ; Acknowledgment date
reminder_count = ##:(0..)                         ; Reminders sent
released = ?                                      ; Released from hold
release_date = date:if released = true            ; Release date

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; IT Actions
; ───────────────────────────────────────────────────────────────────────────────
{.it_actions}
it_hold_implemented = ?                           ; IT implemented technical hold
it_implementation_date = date:if it_hold_implemented = true
retention_policies_suspended = ?                  ; Auto-delete suspended
systems_on_hold[] = :                             ; Systems with hold
backup_retention_extended = ?                     ; Backup retention extended

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; Compliance Tracking
; ───────────────────────────────────────────────────────────────────────────────
{.compliance}
total_custodians = ##:(0..)                       ; Total custodians on hold
acknowledged_count = ##:(0..)                     ; Number acknowledged
pending_acknowledgment = ##:(0..)                 ; Pending acknowledgment
non_compliant[] = :                               ; Non-compliant custodians
escalated = ?                                     ; Compliance escalated
escalation_date = date:if escalated = true        ; Escalation date

{@ediscovery_hold}

; ───────────────────────────────────────────────────────────────────────────────
; Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, modified, partial_release, released, superseded)
status_date = date                                ; Date of status
release_date = date:if status = released          ; Full release date
release_reason = ::if status = released           ; Release reason
release_approved_by = ::if status = released      ; Who approved release

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY COLLECTION
; ═══════════════════════════════════════════════════════════════════════════════
; Data collection record

{@ediscovery_collection}
; Required fields first
collection_date = date                           ; Collection date
collection_name = :                              ; Collection name
collection_type = (forensic, logical, targeted)  ; Collection type

; Collection identification
collection_id = :                                 ; Unique collection ID

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
hold_ref = @ediscovery_hold                       ; Reference to legal hold

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
custodians[] = @ediscovery_custodian              ; Custodians collected
data_sources[] = @ediscovery_data_source          ; Sources collected
date_range_start = date                           ; Date filter start
date_range_end = date                             ; Date filter end
keywords[] = :                                    ; Search keywords used
file_types[] = :                                  ; File types collected
exclusions[] = :                                  ; Exclusion criteria

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Team
; ───────────────────────────────────────────────────────────────────────────────
{.team}
collected_by = :                                  ; Person/team who collected
collection_tool = :                               ; Tool used (Relativity, etc.)
vendor = :                                        ; Vendor name (if outsourced)
supervising_attorney = :                          ; Supervising attorney
it_support = :                                    ; IT support person

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Collection Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.metrics}
total_size_gb = #:(0..)                           ; Total size in GB
total_items = ##:(0..)                            ; Total item count
email_count = ##:(0..)                            ; Email count
document_count = ##:(0..)                         ; Document count
other_count = ##:(0..)                            ; Other item count
compressed_size_gb = #:(0..)                      ; Compressed size
hash_algorithm = :                                ; Hash algorithm used
collection_duration_hours = #:(0..)               ; Duration

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Chain of Custody
; ───────────────────────────────────────────────────────────────────────────────
{.chain_of_custody[]}
action = (collected, copied, processed, received, shipped, stored, transferred)
action_date = timestamp                           ; Action timestamp
performed_by = :                                  ; Person performing action
location = :                                      ; Location
hash_verified = ?                                 ; Hash verification done
notes = :                                         ; Action notes

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Control
; ───────────────────────────────────────────────────────────────────────────────
{.qc}
qc_performed = ?                                  ; QC performed
qc_date = date:if qc_performed = true             ; QC date
qc_by = ::if qc_performed = true                  ; QC performer
spot_check_percentage = #:(0..100):if qc_performed = true
issues_found = ##:(0..):if qc_performed = true    ; Issues found
issues_resolved = ?:if issues_found > 0           ; Issues resolved

{@ediscovery_collection}

; ───────────────────────────────────────────────────────────────────────────────
; Storage
; ───────────────────────────────────────────────────────────────────────────────
{.storage}
storage_location = :                              ; Storage location
storage_type = (cloud, local, network, physical)  ; Storage type
encrypted = ?                                     ; Data encrypted
encryption_method = ::if encrypted = true         ; Encryption method
backup_created = ?                                ; Backup created
backup_location = ::if backup_created = true      ; Backup location
retention_period = :                              ; Retention period

{@ediscovery_collection}

; Status
status = (collected, processing, processed, qa_failed, qa_passed, staged)
status_date = date                                ; Date of status
processing_ref = @ediscovery_processing           ; Reference to processing job


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN eDiscovery Production Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Electronic discovery processing, review, and production following the EDRM
; framework. Covers processing jobs, document review projects with coding
; panels, privilege logging, quality control, and production formatting
; with Bates numbering and load file generation.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../types.schema.odin" as legal
@import "../../common/types.schema.odin" as common

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.legal.ediscovery.production"
version = "1.0.0"
title = "eDiscovery Production Schema"
description = "Processing, review, and production for eDiscovery"

{$derivation}
source[0].authority = "Electronic Discovery Reference Model"
source[0].citation = "EDRM Framework - Processing, Review, Analysis, Production"
source[0].url = "https://edrm.net/frameworks-and-standards/edrm-model/"

source[1].authority = "Federal Rules of Civil Procedure"
source[1].citation = "Rule 34 - Producing Documents"
source[1].url = "https://www.uscourts.gov/rules-policies/current-rules-practice-procedure/federal-rules-civil-procedure"

source[2].authority = "The Sedona Conference"
source[2].citation = "Commentary on ESI Proportionality"
source[2].url = "https://thesedonaconference.org/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Production schema derived from EDRM framework and FRCP requirements"

changelog[0].date = 2025-12-20
changelog[0].change = "Initial eDiscovery production schema"
changelog[0].rationale = "EDRM-compliant production tracking"

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY PROCESSING
; ═══════════════════════════════════════════════════════════════════════════════
; Data processing job

{@ediscovery_processing}
; Required fields first
job_name = :                                     ; Processing job name
processing_date = date                           ; Processing date

; Job identification
job_id = :                                        ; Unique job ID

; ───────────────────────────────────────────────────────────────────────────────
; Source Data
; ───────────────────────────────────────────────────────────────────────────────
{.source}
collection_ref = @ediscovery_collection           ; Source collection
source_size_gb = #:(0..)                          ; Source data size
source_items = ##:(0..)                           ; Source item count
custodians[] = :                                  ; Custodians in processing

{@ediscovery_processing}

; ───────────────────────────────────────────────────────────────────────────────
; Processing Settings
; ───────────────────────────────────────────────────────────────────────────────
{.settings}
processing_tool = :                               ; Tool used (Relativity, etc.)
ocr_enabled = ?                                   ; OCR processing
ocr_languages[] = :                               ; OCR languages
extract_text = ?                                  ; Text extraction
extract_metadata = ?                              ; Metadata extraction
deduplication = (custodian, global, none)         ; Deduplication level
dedupe_method = (hash, md5, sha1, sha256):if deduplication != none
email_threading = ?                               ; Email threading
near_duplicate_analysis = ?                       ; Near-dupe analysis
near_duplicate_threshold = #:(0..100):if near_duplicate_analysis = true

{@ediscovery_processing}

; ───────────────────────────────────────────────────────────────────────────────
; Culling/Filtering
; ───────────────────────────────────────────────────────────────────────────────
{.culling}
date_filter_start = date                          ; Date filter start
date_filter_end = date                            ; Date filter end
file_type_filter = ?                              ; File type filtering
included_types[] = :                              ; Included file types
excluded_types[] = :                              ; Excluded file types
size_filter = ?                                   ; Size filtering
max_file_size_mb = ##:(0..):if size_filter = true
nist_filtering = ?                                ; NIST hash filtering
domain_filtering = ?                              ; Email domain filtering
excluded_domains[] = ::if domain_filtering = true

{@ediscovery_processing}

; ───────────────────────────────────────────────────────────────────────────────
; Processing Results
; ───────────────────────────────────────────────────────────────────────────────
{.results}
items_processed = ##:(0..)                        ; Items processed
items_after_dedupe = ##:(0..)                     ; After deduplication
items_after_culling = ##:(0..)                    ; After culling
duplicates_removed = ##:(0..)                     ; Duplicates removed
nist_filtered = ##:(0..):if culling.nist_filtering = true
exceptions_count = ##:(0..)                       ; Processing exceptions
output_size_gb = #:(0..)                          ; Output size

{@ediscovery_processing}

; Exception details
{.results.exceptions[]}
exception_type = (container_error, corrupt_file, encrypted, password_protected, unsupported_format)
count = ##:(0..)                                  ; Count of this type
sample_files[] = :                                ; Sample file names
resolution = :                                    ; How resolved

{@ediscovery_processing}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Control
; ───────────────────────────────────────────────────────────────────────────────
{.qc}
qc_performed = ?                                  ; QC performed
qc_date = date:if qc_performed = true             ; QC date
qc_by = ::if qc_performed = true                  ; QC performer
sample_size = ##:(0..):if qc_performed = true     ; QC sample size
ocr_accuracy = #:(0..100):if qc_performed = true  ; OCR accuracy %
metadata_accuracy = #:(0..100):if qc_performed = true
issues_found = ##:(0..):if qc_performed = true    ; Issues found
issues_resolved = ?:if issues_found > 0           ; Issues resolved

{@ediscovery_processing}

; Status
status = (completed, failed, in_progress, queued, reprocessing)
status_date = date                                ; Date of status
completion_date = date:if status = completed      ; Completion date
processing_time_hours = #:(0..):if status = completed

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY REVIEW PROJECT
; ═══════════════════════════════════════════════════════════════════════════════
; Document review project

{@ediscovery_review_project}
; Required fields first
project_name = :                                 ; Project name
review_type = (first_pass, privilege, responsiveness, second_pass)

; Project identification
project_id = :                                    ; Unique project ID

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
processing_ref = @ediscovery_processing           ; Source processing job

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Review Platform
; ───────────────────────────────────────────────────────────────────────────────
{.platform}
review_tool = :                                   ; Review platform (Relativity, etc.)
workspace_name = :                                ; Workspace/database name
workspace_id = :                                  ; Platform workspace ID
vendor = :                                        ; Hosting vendor

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Review Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
total_documents = ##:(0..)                        ; Total documents for review
estimated_hours = #:(0..)                         ; Estimated review hours
target_completion = date                          ; Target completion date
review_protocol = :                               ; Review protocol reference
coding_panel_version = :                          ; Coding panel version
privilege_log_required = ?                        ; Privilege log needed

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Review Team
; ───────────────────────────────────────────────────────────────────────────────
{.team}
lead_attorney = @legal_attorney                   ; Lead reviewer
supervising_partner = @legal_attorney             ; Supervising partner
reviewers[] = :                                   ; Reviewer names/IDs
reviewer_count = ##:(0..)                         ; Number of reviewers
vendor_reviewers = ?                              ; Using vendor reviewers
vendor_name = ::if vendor_reviewers = true        ; Vendor name

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Coding Categories
; ───────────────────────────────────────────────────────────────────────────────
{.coding_categories[]}
category_name = :                                 ; Category name
category_type = (issue, privilege, relevance, responsiveness)
options[] = :                                     ; Available options
required = ?                                      ; Required field
multi_select = ?                                  ; Multiple selections allowed

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Analytics/TAR
; ───────────────────────────────────────────────────────────────────────────────
{.tar}
tar_used = ?                                      ; Technology Assisted Review
tar_type = (cal, sar, simple_active, simple_passive):if tar_used = true
seed_set_size = ##:(0..):if tar_used = true       ; Seed set size
training_rounds = ##:(0..):if tar_used = true     ; Training rounds
recall_target = #:(0..100):if tar_used = true     ; Target recall
precision_achieved = #:(0..100):if tar_used = true
elusion_rate = #:(0..100):if tar_used = true      ; Elusion rate achieved
richness = #:(0..100):if tar_used = true          ; Document richness

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Review Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.metrics}
documents_reviewed = ##:(0..)                     ; Documents reviewed
documents_remaining = ##:(0..)                    ; Remaining
responsive_count = ##:(0..)                       ; Marked responsive
non_responsive_count = ##:(0..)                   ; Marked non-responsive
privileged_count = ##:(0..)                       ; Marked privileged
review_rate_docs_hour = #:(0..)                   ; Docs/hour rate
hours_spent = #:(0..)                             ; Total hours spent

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Control
; ───────────────────────────────────────────────────────────────────────────────
{.qc}
qc_sampling = ?                                   ; QC sampling enabled
sample_percentage = #:(0..100):if qc_sampling = true
qc_documents = ##:(0..):if qc_sampling = true     ; Documents QC'd
qc_discrepancy_rate = #:(0..100):if qc_sampling = true
qc_threshold = #:(0..100):if qc_sampling = true   ; Acceptable threshold
escalation_documents = ##:(0..)                   ; Escalated to senior review

{@ediscovery_review_project}

; ───────────────────────────────────────────────────────────────────────────────
; Privilege Review
; ───────────────────────────────────────────────────────────────────────────────
{.privilege}
privilege_review_complete = ?                     ; Privilege review done
privilege_log_entries = ##:(0..)                  ; Privilege log entries
redaction_count = ##:(0..)                        ; Documents with redactions
clawback_count = ##:(0..)                         ; Clawback documents

{@ediscovery_review_project}

; Status
status = (active, completed, on_hold, pending, qc_in_progress)
status_date = date                                ; Date of status
start_date = date                                 ; Review start date
completion_date = date:if status = completed      ; Completion date

; ═══════════════════════════════════════════════════════════════════════════════
; EDISCOVERY PRODUCTION
; ═══════════════════════════════════════════════════════════════════════════════
; Document production

{@ediscovery_production}
; Required fields first
production_date = date                           ; Production date
production_name = :                              ; Production name

; Production identification
production_id = :                                 ; Unique production ID
production_number = :                             ; Production number (VOL001, etc.)

; ───────────────────────────────────────────────────────────────────────────────
; Matter Reference
; ───────────────────────────────────────────────────────────────────────────────
{.matter}
matter_ref = @legal_matter_ref                    ; Reference to matter
case_ref = @legal_case_ref                        ; Reference to case
review_ref = @ediscovery_review_project           ; Source review project

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Production Request
; ───────────────────────────────────────────────────────────────────────────────
{.request}
request_number = :                                ; Request number (RFP #)
requesting_party = :                              ; Who requested
request_date = date                               ; Request date
response_due = date                               ; Response deadline
supplemental = ?                                  ; Supplemental production
supplements_production = ::if supplemental = true ; Production being supplemented

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Production Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
custodians[] = :                                  ; Custodians included
date_range_start = date                           ; Date range start
date_range_end = date                             ; Date range end
search_terms[] = :                                ; Search terms used
bates_range_start = :                             ; Bates range start
bates_range_end = :                               ; Bates range end

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Production Format
; ───────────────────────────────────────────────────────────────────────────────
{.format}
production_format = (native, pdf, tiff)           ; Primary format
native_production = ?                             ; Producing natives
native_file_types[] = ::if native_production = true
load_file_format = (concordance, relativity, summation)
load_file_encoding = :                            ; Character encoding
metadata_fields[] = :                             ; Metadata fields included
text_included = ?                                 ; Extracted text included
text_format = (ocr, searchable_pdf, txt):if text_included = true
image_settings = :                                ; Image settings (DPI, color)
redaction_applied = ?                             ; Redactions applied
confidentiality_stamp = ?                         ; Confidentiality legend
stamp_text = ::if confidentiality_stamp = true    ; Stamp text

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Production Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.metrics}
total_documents = ##:(0..)                        ; Total documents
total_pages = ##:(0..)                            ; Total pages
native_files = ##:(0..):if native_production = true
redacted_documents = ##:(0..):if redaction_applied = true
privileged_withheld = ##:(0..)                    ; Privileged docs withheld
production_size_gb = #:(0..)                      ; Production size

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Privilege Log
; ───────────────────────────────────────────────────────────────────────────────
{.privilege_log}
log_included = ?                                  ; Privilege log included
log_entries = ##:(0..):if log_included = true     ; Log entries
log_format = (csv, pdf, xlsx):if log_included = true
categories_logged[] = ::if log_included = true    ; Privilege categories

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Quality Control
; ───────────────────────────────────────────────────────────────────────────────
{.qc}
qc_performed = ?                                  ; QC performed
qc_date = date:if qc_performed = true             ; QC date
qc_by = ::if qc_performed = true                  ; QC performer
sample_size = ##:(0..):if qc_performed = true     ; Sample size
bates_verified = ?:if qc_performed = true         ; Bates numbering verified
load_file_verified = ?:if qc_performed = true     ; Load file verified
text_verified = ?:if qc_performed = true          ; Text extraction verified
issues_found = ##:(0..):if qc_performed = true    ; Issues found

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Delivery
; ───────────────────────────────────────────────────────────────────────────────
{.delivery}
delivery_method = (courier, electronic, sftp, usb)
delivery_date = date                              ; Delivery date
recipient = :                                     ; Recipient name
recipient_email = *@email                         ; Recipient email
tracking_number = ::if delivery_method = courier  ; Courier tracking
download_link = ::if delivery_method = electronic | delivery_method = sftp
encrypted = ?                                     ; Data encrypted
encryption_password_sent = ?:if encrypted = true  ; Password communicated
delivery_confirmed = ?                            ; Delivery confirmed
confirmation_date = date:if delivery_confirmed = true

{@ediscovery_production}

; ───────────────────────────────────────────────────────────────────────────────
; Certification
; ───────────────────────────────────────────────────────────────────────────────
{.certification}
certification_included = ?                        ; Certification letter
certified_by = ::if certification_included = true ; Certifying attorney
certification_date = date:if certification_included = true
rule_26g_certified = ?                            ; Rule 26(g) certification

{@ediscovery_production}

; Status
status = (cancelled, completed, delivered, in_progress, qc_failed, qc_in_progress, qc_passed)
status_date = date                                ; Date of status


; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Telecom Network Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Network infrastructure including coverage areas, cell sites, outages,
; spectrum licenses, and network performance metrics.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.telecom.network"
version = "1.0.0"
title = "Telecom Network Schema"
description = "Network coverage, cell sites, outages, and spectrum management"

{$derivation}
source[0].authority = "Federal Communications Commission"
source[0].citation = "47 CFR Part 27 - Miscellaneous Wireless Communications Services"
source[0].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-B/part-27"

source[1].authority = "Federal Communications Commission"
source[1].citation = "47 CFR Part 4 - Disruptions to Communications"
source[1].url = "https://www.ecfr.gov/current/title-47/chapter-I/subchapter-A/part-4"

source[2].authority = "3GPP"
source[2].citation = "TS 36.104 - Base Station (BS) radio transmission and reception"
source[2].url = "https://www.3gpp.org/specifications"

source[3].authority = "GSMA"
source[3].citation = "GSMA Network Coverage Maps"
source[3].url = "https://www.gsma.com/coverage/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial network schema"
changelog[0].rationale = "Network structure derived from FCC spectrum and outage reporting requirements"

; ═══════════════════════════════════════════════════════════════════════════════
; CELL SITE
; ═══════════════════════════════════════════════════════════════════════════════
; Cell tower or base station

{@cell_site}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Site Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
site_id = :                                      ; Unique site identifier
site_name = :                                    ; Site name
cell_id = :                                       ; Cell identifier

; ───────────────────────────────────────────────────────────────────────────────
; Site Type
; ───────────────────────────────────────────────────────────────────────────────
site_type = (das, macro, microcell, picocell, small_cell)
ownership = (carrier_owned, leased, rooftop, tower_company)

; ───────────────────────────────────────────────────────────────────────────────
; Location (Required)
; ───────────────────────────────────────────────────────────────────────────────
{.location}
address = @types.address                          ; Site address
latitude = #:(-90..90)                           ; GPS latitude
longitude = #:(-180..180)                        ; GPS longitude
altitude_meters = #:(0..)                         ; Altitude above sea level
height_meters = #:(0..)                           ; Tower/antenna height

{@cell_site}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Area
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
coverage_radius_km = #:(0..)                      ; Approximate coverage radius
azimuth_degrees = ##:(0..359)                     ; Antenna azimuth
beam_width_degrees = ##:(1..360)                  ; Antenna beam width
sectors = ##:(1..12)                              ; Number of sectors

{@cell_site}

; ───────────────────────────────────────────────────────────────────────────────
; Technology and Capabilities
; ───────────────────────────────────────────────────────────────────────────────
{.technology}
network_generations[] = ("2g", "3g", "4g", "5g")  ; Supported network generations
technologies[] = (cdma, evdo, gsm, lte, nr, umts) ; Technologies deployed
frequency_bands[] = :                             ; Frequency bands (e.g., "700", "850", "1900", "2500")
carrier_aggregation = ?                           ; Carrier aggregation supported
mimo_layers = ##:(1..8)                           ; MIMO layer count
beamforming = ?                                   ; Beamforming capable

{@cell_site}

; ───────────────────────────────────────────────────────────────────────────────
; Equipment
; ───────────────────────────────────────────────────────────────────────────────
{.equipment}
base_station_vendor = :                           ; Equipment vendor
base_station_model = :                            ; Equipment model
rru_count = ##:(0..)                              ; Remote Radio Unit count
antenna_count = ##:(0..)                          ; Antenna count
backhaul_type = (fiber, microwave, satellite)

{@cell_site}

; ───────────────────────────────────────────────────────────────────────────────
; Site Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, decommissioned, maintenance, offline, planned, under_construction)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Operational Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
commissioned_date = date                          ; Site commissioned date
last_maintenance = date                           ; Last maintenance date
next_maintenance = date                           ; Next scheduled maintenance

{@cell_site}

; ───────────────────────────────────────────────────────────────────────────────
; Performance Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.performance}
uptime_percent = #:(0..100)                       ; Uptime percentage
avg_throughput_mbps = #:(0..)                     ; Average throughput (Mbps)
peak_throughput_mbps = #:(0..)                    ; Peak throughput (Mbps)
connected_users_avg = ##:(0..)                    ; Average connected users
connected_users_peak = ##:(0..)                   ; Peak connected users

{@cell_site}

; ═══════════════════════════════════════════════════════════════════════════════
; COVERAGE AREA
; ═══════════════════════════════════════════════════════════════════════════════
; Network coverage region or zone

{@coverage_area}
; ───────────────────────────────────────────────────────────────────────────────
; Area Identification
; ───────────────────────────────────────────────────────────────────────────────
area_id = :                                      ; Unique area identifier
area_name = :                                    ; Area name

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Boundaries
; ───────────────────────────────────────────────────────────────────────────────
{.geography}
country = :(2..3)                                ; ISO country code
state_province = :(2)                             ; State/province code
county = :                                        ; County name
city = :                                          ; City name
zip_codes[] = :                                   ; ZIP/postal codes covered
area_type = (city, county, metro, rural, state, suburban, urban)

{@coverage_area}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Quality
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
coverage_type = (excellent, fair, good, marginal, no_coverage, partner_coverage, roaming)
network_generation = ("2g", "3g", "4g", "5g")    ; Primary network generation
indoor_coverage = ?                               ; Indoor coverage available
outdoor_coverage = ?                              ; Outdoor coverage available
coverage_percent = #:(0..100)                     ; Population coverage percentage

{@coverage_area}

; ───────────────────────────────────────────────────────────────────────────────
; Service Availability
; ───────────────────────────────────────────────────────────────────────────────
{.services}
voice_available = ?                               ; Voice service available
data_available = ?                                ; Data service available
sms_available = ?                                 ; SMS available
lte_available = ?                                 ; LTE available
nr_available = ?                                  ; 5G NR available
volte_available = ?                               ; VoLTE available

{@coverage_area}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK OUTAGE
; ═══════════════════════════════════════════════════════════════════════════════
; Network service disruption or outage

{@outage}
= @types.base_outage

; ───────────────────────────────────────────────────────────────────────────────
; Outage Identification (Additional telecom fields)
; ───────────────────────────────────────────────────────────────────────────────
incident_id = :                                   ; External incident ID

; ───────────────────────────────────────────────────────────────────────────────
; Outage Type and Severity (Additional telecom fields)
; ───────────────────────────────────────────────────────────────────────────────
service_impact = (data, messaging, voice)

; ───────────────────────────────────────────────────────────────────────────────
; Affected Area
; ───────────────────────────────────────────────────────────────────────────────
{.affected}
affected_sites[] = :                              ; Affected cell site IDs
affected_area = :                                 ; Geographic area description
affected_services[] = :                           ; Affected service types
users_affected = ##:(0..)                         ; Estimated users affected
geographic_scope = (city, county, local, multi_state, national, regional, state)

{@outage}

; ───────────────────────────────────────────────────────────────────────────────
; Cause and Resolution
; ───────────────────────────────────────────────────────────────────────────────
{.cause}
cause_category = (
    equipment_failure,
    fiber_cut,
    human_error,
    maintenance,
    natural_disaster,
    power_failure,
    software_issue,
    third_party,
    weather
)
root_cause = :                                    ; Root cause description
resolution = :                                    ; Resolution description

{@outage}

; ───────────────────────────────────────────────────────────────────────────────
; Outage Status
; ───────────────────────────────────────────────────────────────────────────────
status = (investigating, monitoring, resolved, scheduled)
status_updated = timestamp                        ; Last status update timestamp

; ───────────────────────────────────────────────────────────────────────────────
; Communications
; ───────────────────────────────────────────────────────────────────────────────
{.communications}
customer_notification_sent = ?                    ; Customers notified
notification_time = timestamp                     ; Notification sent timestamp
public_statement = :                              ; Public statement text
estimated_restoration = timestamp                 ; Estimated restoration time

{@outage}

; ───────────────────────────────────────────────────────────────────────────────
; FCC Reporting (for qualifying outages)
; ───────────────────────────────────────────────────────────────────────────────
{.fcc_reporting}
reportable = ?                                    ; FCC reportable outage
report_filed = ?                                  ; Report filed with FCC
nors_report_id = :                                ; NORS report ID
report_filed_date = date                          ; Report filing date

{@outage}

; ═══════════════════════════════════════════════════════════════════════════════
; SPECTRUM LICENSE
; ═══════════════════════════════════════════════════════════════════════════════
; FCC spectrum license allocation

{@spectrum_license}
; ───────────────────────────────────────────────────────────────────────────────
; License Identification (Required)
; ───────────────────────────────────────────────────────────────────────────────
license_id = :                                   ; Unique license identifier
call_sign = :                                    ; FCC call sign
fcc_license_number = :                            ; FCC license number

; ───────────────────────────────────────────────────────────────────────────────
; Licensee
; ───────────────────────────────────────────────────────────────────────────────
{.licensee}
licensee_name = :                                ; Licensee name
licensee_id = :                                   ; FCC Registration Number (FRN)
licensee_type = (carrier, government, private, wireless_carrier)

{@spectrum_license}

; ───────────────────────────────────────────────────────────────────────────────
; Spectrum Details
; ───────────────────────────────────────────────────────────────────────────────
{.spectrum}
frequency_band = :                               ; Frequency band (e.g., "700 MHz", "AWS", "PCS")
lower_frequency_mhz = #:(0..)                    ; Lower frequency (MHz)
upper_frequency_mhz = #:(0..)                    ; Upper frequency (MHz)
bandwidth_mhz = #:(0..)                          ; Bandwidth (MHz)
channel_block = :                                 ; Channel block identifier

{@spectrum_license}

; ───────────────────────────────────────────────────────────────────────────────
; Service Type
; ───────────────────────────────────────────────────────────────────────────────
service_type = (
    aws,
    broadband,
    cellular,
    microwave,
    pcs,
    point_to_point,
    wireless
)
radio_service_code = :                            ; FCC radio service code

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.coverage}
license_area = :                                 ; License area description
market_type = (bea, cma, ea, mea, mta, nationwide, rsa)
market_code = :                                   ; Market identifier code
states_provinces[] = :(2)                         ; States/provinces covered
population_covered = ##:(0..)                     ; Population in license area

{@spectrum_license}

; ───────────────────────────────────────────────────────────────────────────────
; License Dates
; ───────────────────────────────────────────────────────────────────────────────
{.dates}
grant_date = date                                ; License grant date
effective_date = date                            ; License effective date
expiration_date = date                           ; License expiration date
cancellation_date = date                          ; Cancellation date (if applicable)

{@spectrum_license}

; ───────────────────────────────────────────────────────────────────────────────
; License Status
; ───────────────────────────────────────────────────────────────────────────────
status = (active, cancelled, expired, pending, renewed, suspended)
status_date = date                                ; Status change date

; ───────────────────────────────────────────────────────────────────────────────
; Build-Out Requirements
; ───────────────────────────────────────────────────────────────────────────────
{.buildout}
buildout_deadline = date                          ; Construction deadline
buildout_complete = ?                             ; Build-out completed
buildout_certification_date = date                ; Certification date
coverage_requirement_percent = #:(0..100)         ; Required coverage percentage

{@spectrum_license}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK PERFORMANCE METRIC
; ═══════════════════════════════════════════════════════════════════════════════
; Network quality and performance measurement

{@network_metric}
; ───────────────────────────────────────────────────────────────────────────────
; Metric Identification
; ───────────────────────────────────────────────────────────────────────────────
metric_id = :                                    ; Unique metric identifier
measurement_time = timestamp                     ; Measurement timestamp

; ───────────────────────────────────────────────────────────────────────────────
; Metric Type
; ───────────────────────────────────────────────────────────────────────────────
metric_type = (
    availability,
    call_drop_rate,
    call_setup_success_rate,
    data_throughput,
    handover_success_rate,
    latency,
    packet_loss,
    signal_strength
)

; ───────────────────────────────────────────────────────────────────────────────
; Measurement Scope
; ───────────────────────────────────────────────────────────────────────────────
{.scope}
scope_type = (cell_site, market, national, network, regional)
cell_site_ref = :                                 ; Cell site reference
area_ref = :                                      ; Coverage area reference
network_type = ("2g", "3g", "4g", "5g")           ; Network generation

{@network_metric}

; ───────────────────────────────────────────────────────────────────────────────
; Metric Values
; ───────────────────────────────────────────────────────────────────────────────
{.values}
value = #                                        ; Metric value
unit = :                                         ; Unit of measurement
sample_count = ##:(0..)                           ; Number of samples
min_value = #                                     ; Minimum value
max_value = #                                     ; Maximum value
avg_value = #                                     ; Average value
percentile_95 = #                                 ; 95th percentile value

{@network_metric}

; ═══════════════════════════════════════════════════════════════════════════════
; NETWORK ALARM
; ═══════════════════════════════════════════════════════════════════════════════
; Network equipment or service alarm

{@network_alarm}
; ───────────────────────────────────────────────────────────────────────────────
; Alarm Identification
; ───────────────────────────────────────────────────────────────────────────────
alarm_id = :                                     ; Unique alarm identifier
alarm_code = :                                   ; Alarm code
sequence_number = ##:(0..)                        ; Alarm sequence number

; ───────────────────────────────────────────────────────────────────────────────
; Alarm Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
raised_time = timestamp                          ; Alarm raised timestamp
cleared_time = timestamp                          ; Alarm cleared timestamp
acknowledged_time = timestamp                     ; Alarm acknowledged timestamp
duration_minutes = ##:(0..)                       ; Alarm duration

{@network_alarm}

; ───────────────────────────────────────────────────────────────────────────────
; Alarm Details
; ───────────────────────────────────────────────────────────────────────────────
alarm_type = (communication, environmental, equipment, performance, processing, quality_of_service)
severity = (critical, indeterminate, major, minor, warning)
description = :                                  ; Alarm description

; ───────────────────────────────────────────────────────────────────────────────
; Alarm Source
; ───────────────────────────────────────────────────────────────────────────────
{.source}
element_type = (base_station, core_network, radio_unit, router, switch)
element_id = :                                    ; Network element identifier
cell_site_ref = :                                 ; Cell site reference (if applicable)

{@network_alarm}

; ───────────────────────────────────────────────────────────────────────────────
; Alarm Status
; ───────────────────────────────────────────────────────────────────────────────
status = (acknowledged, active, cleared, pending)
status_updated = timestamp                        ; Status update timestamp

; ───────────────────────────────────────────────────────────────────────────────
; Response
; ───────────────────────────────────────────────────────────────────────────────
{.response}
acknowledged_by = :                               ; User who acknowledged
assigned_to = :                                   ; Technician/team assigned
escalated = ?                                     ; Alarm escalated
escalation_level = ##:(0..)                       ; Escalation level
resolution_notes = :                              ; Resolution notes

{@network_alarm}

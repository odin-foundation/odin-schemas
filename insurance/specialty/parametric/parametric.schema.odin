; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Parametric Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Parametric (index-based) insurance providing predetermined payouts triggered by
; measurable events rather than traditional loss adjustment. Covers weather,
; catastrophe, agricultural, and business interruption parameters.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../common/types.schema.odin" as types
@import "../../common/party.schema.odin" as party

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.specialty.parametric"
version = "1.0.0"
title = "Parametric Insurance Schema"
description = "Index-based insurance with predetermined payouts triggered by measured parameters"

{$derivation}
source[0].authority = "National Oceanic and Atmospheric Administration"
source[0].citation = "NOAA Weather.gov API and Climate Data Online Services"
source[0].url = "https://www.weather.gov/documentation/services-web-api"

source[1].authority = "U.S. Geological Survey"
source[1].citation = "USGS ShakeMap and Earthquake Hazards Program"
source[1].url = "https://earthquake.usgs.gov/data/shakemap/"

source[2].authority = "National Hurricane Center"
source[2].citation = "NHC Tropical Cyclone Reports and Best Track Data"
source[2].url = "https://www.nhc.noaa.gov/"

source[3].authority = "World Bank Group"
source[3].citation = "Disaster Risk Financing and Insurance Program"
source[3].url = "https://www.worldbank.org/en/programs/disaster-risk-financing-and-insurance-program"

source[4].authority = "Insurance Services Office / Verisk"
source[4].citation = "Property Claims Services (PCS) Industry Loss Estimates"
source[4].url = "https://www.verisk.com/insurance/products/property-claim-services/"

source[5].authority = "Swiss Re"
source[5].citation = "SIGMA Natural Catastrophe Statistics"
source[5].url = "https://www.swissre.com/institute/research/sigma-research.html"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Parametric insurance schema derived from public government data specifications, World Bank resources, and academic literature on index-based risk transfer"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial parametric insurance schema"
changelog[0].rationale = "Comprehensive coverage of weather, CAT, and capital markets parametric products"

; ═══════════════════════════════════════════════════════════════════════════════
; Data Source Definition
; ═══════════════════════════════════════════════════════════════════════════════
; Authoritative data sources for trigger verification - the objective third
; party that provides the index measurement determining payout eligibility.

{@parametric_data_source}
source_id = :                                ; Unique identifier for this data source

; ───────────────────────────────────────────────────────────────────────────────
; Source Authority
; ───────────────────────────────────────────────────────────────────────────────
name = :                                     ; Name of the data source provider
authority_type = (
    commercial_provider,
    government_agency,
    industry_consortium,
    international_organization,
    research_institution
)

; Government/Official Sources
agency = :                                   ; Government agency name if applicable
country = :(2..3)                            ; ISO country code
jurisdiction = :                             ; State, province, or regional jurisdiction

; ───────────────────────────────────────────────────────────────────────────────
; Data Access
; ───────────────────────────────────────────────────────────────────────────────
api_endpoint = :                             ; URL or endpoint for data access
data_format = (csv, fixed_width, geojson, json, netcdf, xml)  ; Format of data provided
access_method = (api, ftp, manual_request, real_time_feed, web_portal)  ; How to retrieve data
update_frequency = (annually, continuous, daily, event_based, hourly, monthly)  ; How often data is updated

; ───────────────────────────────────────────────────────────────────────────────
; Data Characteristics
; ───────────────────────────────────────────────────────────────────────────────
resolution = :                           ; Spatial/temporal resolution
latency = :                              ; Time from event to data availability
historical_availability = :              ; How far back data exists
certification_available = ?                     ; Can provide certified data for legal use

; ───────────────────────────────────────────────────────────────────────────────
; Common Data Sources
; ───────────────────────────────────────────────────────────────────────────────
source_type = (
    copernicus_cems,                            ; Copernicus Emergency Management Service
    emsc,                                       ; European-Mediterranean Seismological Centre
    era5_reanalysis,                            ; ECMWF ERA5 global reanalysis
    firms_viirs,                                ; NASA FIRMS fire detection
    jma,                                        ; Japan Meteorological Agency
    jma_rsmc_tokyo,                             ; JMA Regional Specialized Met Centre
    jtwc,                                       ; Joint Typhoon Warning Center
    munichre_natcat,                            ; Munich Re NatCatSERVICE
    nasa_gpm,                                   ; NASA Global Precipitation Measurement
    noaa_cdo,                                   ; NOAA Climate Data Online
    noaa_ghcn,                                  ; NOAA Global Historical Climatology Network
    noaa_hurdat,                                ; NOAA Hurricane Database
    noaa_ibtracs,                               ; NOAA International Best Track Archive
    noaa_isd,                                   ; NOAA Integrated Surface Database
    noaa_ncei,                                  ; NOAA National Centers for Environmental Info
    noaa_nhc,                                   ; NOAA National Hurricane Center
    noaa_nws,                                   ; NOAA National Weather Service
    pcs,                                        ; Verisk Property Claims Services
    perils,                                     ; PERILS AG industry loss index
    private_weather_network,                    ; Commercial weather station networks
    rms_hwind,                                  ; RMS HWind post-storm analysis
    satellite_imagery,                          ; General satellite-based measurement
    sigma,                                      ; Swiss Re SIGMA
    usgs_earthquake,                            ; USGS Earthquake Hazards Program
    usgs_shakemap,                              ; USGS ShakeMap ground motion
    usgs_streamflow                             ; USGS stream gauge network
)

; ═══════════════════════════════════════════════════════════════════════════════
; Geographic Scope Definition
; ═══════════════════════════════════════════════════════════════════════════════
; Defines the geographic area where the parametric trigger applies.

{@parametric_geographic_scope}
scope_id = :                                 ; Unique identifier for this geographic scope

; ───────────────────────────────────────────────────────────────────────────────
; Scope Type
; ───────────────────────────────────────────────────────────────────────────────
scope_type = (
    cat_in_a_box,                               ; Polygon zone boundary
    cat_in_a_circle,                            ; Radius from center point
    cat_in_a_grid,                              ; Grid cell reference
    country,
    custom_polygon,
    grid_cells,
    named_region,
    point_location,
    radius_from_point,
    state_province,
    zip_postal_code
)

; ───────────────────────────────────────────────────────────────────────────────
; Point Location (for radius-based or point triggers)
; ───────────────────────────────────────────────────────────────────────────────
{.point}
latitude = #:(-90..90)                       ; Point latitude in decimal degrees
longitude = #:(-180..180)                    ; Point longitude in decimal degrees
radius_km = #:(0..1000)                      ; Radius in kilometers from point
radius_miles = #:(0..621)                    ; Radius in miles from point

{@parametric_geographic_scope}

; ───────────────────────────────────────────────────────────────────────────────
; Bounding Box (for cat-in-a-box)
; ───────────────────────────────────────────────────────────────────────────────
{.bounding_box}
north_latitude = #:(-90..90)                 ; Northern boundary latitude
south_latitude = #:(-90..90)                 ; Southern boundary latitude
east_longitude = #:(-180..180)               ; Eastern boundary longitude
west_longitude = #:(-180..180)               ; Western boundary longitude
:invariant north_latitude >= south_latitude

{@parametric_geographic_scope}

; ───────────────────────────────────────────────────────────────────────────────
; Named Locations
; ───────────────────────────────────────────────────────────────────────────────
country_code = :(2..3)                       ; ISO country code
state_province_codes[] = :(2..10)            ; State or province codes
postal_codes[] = :                           ; Zip or postal codes
named_region = :                         ; e.g., "Florida Panhandle", "San Francisco Bay Area"
custom_region_id = :                         ; Custom region identifier

; ───────────────────────────────────────────────────────────────────────────────
; Grid Reference
; ───────────────────────────────────────────────────────────────────────────────
{.grid}
grid_system = (custom, geohash, maidenhead, mgrs, plus_codes, what3words)  ; Grid system used
grid_resolution = :                       ; Grid cell size
grid_cells[] = :                             ; Array of grid cell identifiers

{@parametric_geographic_scope}

; ───────────────────────────────────────────────────────────────────────────────
; Polygon Definition (GeoJSON-style)
; ───────────────────────────────────────────────────────────────────────────────
{.polygon}
coordinates_json = :                         ; GeoJSON polygon coordinates
wkt = :                                      ; Well-Known Text format

{@parametric_geographic_scope}

; ═══════════════════════════════════════════════════════════════════════════════
; Trigger Definition
; ═══════════════════════════════════════════════════════════════════════════════
; The core parametric trigger - defines what is measured, thresholds, and
; how payout is calculated relative to the measured value.

{@parametric_trigger}
trigger_id = :                               ; Unique identifier for this trigger

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Identification
; ───────────────────────────────────────────────────────────────────────────────
name = :                                     ; Trigger name
description = :                              ; Description of trigger conditions

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Generation
; ───────────────────────────────────────────────────────────────────────────────
; First generation: Single parameter (magnitude, location)
; Second generation: Modeled or recorded values at specific locations
; Third generation: Modeled loss/impact at insured locations
trigger_generation = (first, second, third)  ; Sophistication level of trigger

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Category
; ───────────────────────────────────────────────────────────────────────────────
trigger_category = (
    agriculture,                                ; Crop yield, soil moisture
    climate_index,                              ; Climate oscillation indices
    earthquake,                                 ; Seismic events
    flood,                                      ; River gauge, precipitation
    industry_loss,                              ; PCS, PERILS industry estimates
    pandemic,                                   ; Disease outbreak indices
    tropical_cyclone,                           ; Hurricane, typhoon, cyclone
    volcanic,                                   ; Volcanic eruption indices
    weather,                                    ; Temperature, rain, wind
    wildfire                                    ; Fire detection, burn area
)

; ───────────────────────────────────────────────────────────────────────────────
; Measurement Parameter
; ───────────────────────────────────────────────────────────────────────────────
measurement_parameter = (
    burned_area,                                ; Wildfire burn area
    central_pressure,                           ; Minimum central pressure
    crop_yield_index,                           ; Yield relative to average
    custom_index,                               ; Custom defined index
    cyclone_category,                           ; Saffir-Simpson category
    degree_days_cooling,                        ; Cooling degree days (CDD)
    degree_days_heating,                        ; Heating degree days (HDD)
    evapotranspiration,                         ; ET water loss
    ground_acceleration_pga,                    ; Peak Ground Acceleration
    ground_velocity_pgv,                        ; Peak Ground Velocity
    humidity_relative,                          ; Relative humidity %
    industry_loss_estimate,                     ; PCS/PERILS loss estimate
    max_sustained_wind,                         ; Maximum sustained wind
    mmi_intensity,                              ; Modified Mercalli Intensity
    moment_magnitude,                           ; Earthquake magnitude (Mw)
    ndvi_vegetation_index,                      ; Satellite vegetation health
    precipitation_cumulative,                   ; Total rainfall over period
    precipitation_daily,                        ; Daily rainfall
    precipitation_deficit,                      ; Rainfall below normal
    precipitation_excess,                       ; Rainfall above normal
    radius_max_wind,                            ; Radius of maximum winds
    river_flow_rate,                            ; Discharge rate
    river_gauge_height,                         ; Stream gauge level
    shake_intensity,                            ; ShakeMap intensity measure
    snowfall,                                   ; Snow accumulation
    soil_moisture,                              ; Soil moisture content
    storm_surge,                                ; Storm surge height
    temperature_maximum,                        ; Daily high temperature
    temperature_mean,                           ; Average temperature
    temperature_minimum,                        ; Daily low temperature
    track_distance,                             ; Distance from track centerline
    wind_gust,                                  ; Peak gust speed
    wind_sustained                              ; Sustained wind speed
)

; ───────────────────────────────────────────────────────────────────────────────
; Measurement Units
; ───────────────────────────────────────────────────────────────────────────────
measurement_unit = (
    celsius,
    centimeters,
    centimeters_per_second,                     ; For PGV
    fahrenheit,
    feet,
    g_force,                                    ; For PGA
    hectares,
    inches,
    kelvin,
    kilometers,
    knots,
    meters,
    miles,
    miles_per_hour,
    millibars,
    millimeters,
    percent,
    richter_scale,
    usd_billions,
    usd_millions
)

; ───────────────────────────────────────────────────────────────────────────────
; Threshold Values
; ───────────────────────────────────────────────────────────────────────────────
{.threshold}
; Primary threshold (attachment point)
trigger_threshold = #                        ; Value that triggers payout
operator = (equal, greater_than, greater_than_or_equal, less_than, less_than_or_equal, range)  ; Comparison operator
range_minimum = #                            ; Minimum value for range-based triggers
range_maximum = #                            ; Maximum value for range-based triggers

; Exhaustion point (for tiered payouts)
exhaustion_threshold = #                     ; Value at which maximum payout is reached

; Event definition (for occurrence-based)
event_duration_hours = ##                    ; Event duration in hours
event_duration_days = ##                     ; Event duration in days
waiting_period_hours = ##                    ; Hours before trigger can activate
waiting_period_days = ##                     ; Days before trigger can activate

{@parametric_trigger}

; ───────────────────────────────────────────────────────────────────────────────
; Measurement Period
; ───────────────────────────────────────────────────────────────────────────────
{.measurement_period}
period_type = (annual, custom, daily, event_based, monthly, seasonal, weekly)  ; Type of measurement period
effective = date                             ; Period effective date
expiration = date                            ; Period expiration date
reference_period = :                     ; e.g., "June 1 - November 30"

{@parametric_trigger}

; ───────────────────────────────────────────────────────────────────────────────
; Data Source
; ───────────────────────────────────────────────────────────────────────────────
data_source = @parametric_data_source        ; Reference to data source definition

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Scope
; ───────────────────────────────────────────────────────────────────────────────
geographic_scope = @parametric_geographic_scope  ; Reference to geographic scope definition

; ═══════════════════════════════════════════════════════════════════════════════
; Payout Structure Definition
; ═══════════════════════════════════════════════════════════════════════════════
; Defines how the payout is calculated once a trigger is activated.

{@parametric_payout_structure}
payout_id = :                                ; Unique identifier for payout structure

; ───────────────────────────────────────────────────────────────────────────────
; Payout Type
; ───────────────────────────────────────────────────────────────────────────────
payout_type = (
    binary,                                     ; Full payout when trigger is met
    linear,                                     ; Proportional between attachment and exhaustion
    step,                                       ; Stepped increases
    tiered                                      ; Multiple discrete tiers
)

; ───────────────────────────────────────────────────────────────────────────────
; Maximum Limits
; ───────────────────────────────────────────────────────────────────────────────
maximum_payout = #$:(0..)                    ; Overall maximum payout
maximum_payout_per_event = #$:(0..)          ; Maximum payout per single event
maximum_payout_annual = #$:(0..)             ; Maximum payout per year
policy_aggregate = #$:(0..)                  ; Total policy aggregate limit

; ───────────────────────────────────────────────────────────────────────────────
; Binary Payout (all or nothing)
; ───────────────────────────────────────────────────────────────────────────────
{.binary}
payout_amount = #$:(0..):if payout_type = binary  ; Fixed payout amount
payout_percentage = ##:(0..100):if payout_type = binary  ; Payout as percentage of limit

{@parametric_payout_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Tiered Payout Structure
; ───────────────────────────────────────────────────────────────────────────────
{.tiers[]}
tier_number = ##                             ; Tier sequence number
threshold_minimum = #                        ; Minimum threshold for this tier
threshold_maximum = #                        ; Maximum threshold for this tier
payout_amount = #$:(0..)                     ; Payout amount for this tier
payout_percentage = ##:(0..100)              ; Payout percentage for this tier
description = :                              ; Description of tier

{@parametric_payout_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Linear Payout (proportional)
; ───────────────────────────────────────────────────────────────────────────────
{.linear}
attachment_point = #:if payout_type = linear  ; Threshold where payout begins
exhaustion_point = #:if payout_type = linear  ; Threshold where maximum payout is reached
minimum_payout = #$:(0..):if payout_type = linear  ; Minimum payout amount
maximum_payout = #$:(0..):if payout_type = linear  ; Maximum payout amount
interpolation = (linear, step_function):if payout_type = linear  ; Interpolation method

{@parametric_payout_structure}

; ───────────────────────────────────────────────────────────────────────────────
; Payout Timing
; ───────────────────────────────────────────────────────────────────────────────
{.timing}
settlement_period_days = ##            ; Days from trigger to payment
expedited_payment_available = ?              ; Whether expedited payment is available
expedited_payment_threshold = #$:(0..)       ; Threshold for expedited payment eligibility

{@parametric_payout_structure}

; ═══════════════════════════════════════════════════════════════════════════════
; Weather Parametric Product
; ═══════════════════════════════════════════════════════════════════════════════
; Weather-based parametric insurance for temperature, rainfall, wind, etc.

{@weather_parametric}
coverage_id = :                              ; Unique identifier for weather coverage

; ───────────────────────────────────────────────────────────────────────────────
; Weather Peril Type
; ───────────────────────────────────────────────────────────────────────────────
peril = (
    drought,
    excessive_heat,
    excessive_precipitation,
    flood,
    freeze,
    frost,
    hail,
    hurricane_named_storm,
    ice_storm,
    insufficient_precipitation,
    lightning,
    snowfall,
    tornado,
    wildfire,
    wind
)

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Configuration
; ───────────────────────────────────────────────────────────────────────────────
trigger = @parametric_trigger                ; Reference to trigger definition

; ───────────────────────────────────────────────────────────────────────────────
; Payout Structure
; ───────────────────────────────────────────────────────────────────────────────
payout_structure = @parametric_payout_structure  ; Reference to payout structure

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Period
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                        ; Coverage effective date
expiration_date = date                       ; Coverage expiration date
:invariant expiration_date > effective_date

; Seasonal period (if applicable)
seasonal_start_month = ##:(1..12)            ; Start month of seasonal coverage
seasonal_start_day = ##:(1..31)              ; Start day of seasonal coverage
seasonal_end_month = ##:(1..12)              ; End month of seasonal coverage
seasonal_end_day = ##:(1..31)                ; End day of seasonal coverage

; ───────────────────────────────────────────────────────────────────────────────
; Weather Station Reference
; ───────────────────────────────────────────────────────────────────────────────
{.weather_station}
station_id = :                               ; Weather station identifier
station_name = :                             ; Weather station name
wmo_id = :                                ; World Meteorological Organization ID
icao_code = :(4)                                ; Airport ICAO code
latitude = #:(-90..90)                       ; Station latitude
longitude = #:(-180..180)                    ; Station longitude
elevation_meters = #:(-500..10000)           ; Station elevation in meters
distance_from_risk_km = #:(0..500)           ; Distance from insured location in km

{@weather_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Historical Reference
; ───────────────────────────────────────────────────────────────────────────────
{.historical}
reference_period_start = date                ; Historical reference period start date
reference_period_end = date                  ; Historical reference period end date
reference_period_years = ##                  ; Number of years in reference period
baseline_value = #                           ; Historical baseline value
standard_deviation = #                       ; Standard deviation of historical values

{@weather_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                            ; Premium amount
rate_on_line = #:(0..100)                       ; Premium as % of limit

{@weather_parametric}

; ═══════════════════════════════════════════════════════════════════════════════
; Earthquake Parametric Product
; ═══════════════════════════════════════════════════════════════════════════════
; Seismic event-based parametric insurance using USGS data.

{@earthquake_parametric}
coverage_id = :                              ; Unique identifier for earthquake coverage

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Type
; ───────────────────────────────────────────────────────────────────────────────
trigger_type = (
    cat_in_a_box,                               ; Epicenter within polygon, magnitude threshold
    cat_in_a_circle,                            ; Epicenter within radius of point
    shakemap_intensity,                         ; Ground motion at specific location
    shakemap_pga,                               ; Peak Ground Acceleration at location
    shakemap_pgv                                ; Peak Ground Velocity at location
)

; ───────────────────────────────────────────────────────────────────────────────
; Magnitude Trigger (first generation)
; ───────────────────────────────────────────────────────────────────────────────
{.magnitude_trigger}
minimum_magnitude = #:(0..10)                   ; Richter/Moment magnitude
maximum_depth_km = #:(0..700)                   ; Focal depth limit
epicenter_zone = @parametric_geographic_scope  ; Geographic zone for epicenter

{@earthquake_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; ShakeMap Trigger (second generation)
; ───────────────────────────────────────────────────────────────────────────────
{.shakemap_trigger}
; Peak Ground Acceleration (g-force)
pga_threshold = #                               ; Threshold in g (0.01g = light, 1g+ = extreme)

; Peak Ground Velocity (cm/s)
pgv_threshold = #:(0..500)                      ; Threshold in cm/s

; Modified Mercalli Intensity
mmi_threshold = #:(1..12)                       ; MMI I-XII

; Location for measurement
measurement_latitude = #:(-90..90)           ; Latitude of measurement location
measurement_longitude = #:(-180..180)        ; Longitude of measurement location
measurement_address = :                      ; Street address of measurement location

{@earthquake_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Configuration
; ───────────────────────────────────────────────────────────────────────────────
trigger = @parametric_trigger                ; Reference to trigger definition

; ───────────────────────────────────────────────────────────────────────────────
; Payout Structure
; ───────────────────────────────────────────────────────────────────────────────
payout_structure = @parametric_payout_structure  ; Reference to payout structure

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Period
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                        ; Coverage effective date
expiration_date = date                       ; Coverage expiration date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                            ; Premium amount
rate_on_line = #:(0..100)                    ; Premium as percentage of limit

{@earthquake_parametric}

; ═══════════════════════════════════════════════════════════════════════════════
; Hurricane/Tropical Cyclone Parametric Product
; ═══════════════════════════════════════════════════════════════════════════════
; Named storm parametric insurance using NHC/JTWC data.

{@hurricane_parametric}
coverage_id = :                              ; Unique identifier for hurricane coverage

; ───────────────────────────────────────────────────────────────────────────────
; Basin
; ───────────────────────────────────────────────────────────────────────────────
basin = (
    atlantic,                                   ; North Atlantic
    central_pacific,                            ; Central North Pacific
    east_pacific,                               ; Eastern North Pacific
    north_indian,                               ; North Indian Ocean
    south_indian,                               ; South Indian Ocean
    south_pacific,                              ; South Pacific
    west_pacific                                ; Western North Pacific (typhoons)
)

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Type
; ───────────────────────────────────────────────────────────────────────────────
trigger_type = (
    cat_in_a_box,                               ; Storm center enters box at threshold intensity
    cat_in_a_circle,                            ; Storm center within radius of point
    cat_in_a_grid,                              ; Storm affects specified grid cells
    landfall,                                   ; Landfall at specific location/region
    track_proximity,                            ; Track passes within distance
    wind_at_location                            ; Wind speed measured at specific point
)

; ───────────────────────────────────────────────────────────────────────────────
; Intensity Threshold
; ───────────────────────────────────────────────────────────────────────────────
{.intensity}
; Saffir-Simpson Category
minimum_category = ##:(1..5)                    ; Cat 1-5

; Wind Speed
minimum_sustained_wind_mph = ##:(39..200)       ; Sustained winds
minimum_sustained_wind_kt = ##:(34..174)        ; Sustained winds in knots
minimum_gust_mph = ##:(50..250)
minimum_gust_kt = ##:(43..217)

; Central Pressure
maximum_central_pressure_mb = ##:(870..1013)    ; Lower = more intense

{@hurricane_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Track-Based Trigger
; ───────────────────────────────────────────────────────────────────────────────
{.track_trigger}
; Reference point for track proximity
reference_latitude = #:(-90..90)             ; Reference point latitude
reference_longitude = #:(-180..180)          ; Reference point longitude
reference_address = :                        ; Reference point address

; Maximum distance from track
track_proximity_km = #:(0..500)              ; Maximum distance from track in km
track_proximity_miles = #:(0..310)           ; Maximum distance from track in miles

; Landfall zone
landfall_zone = @parametric_geographic_scope  ; Geographic zone for landfall

{@hurricane_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Wind at Location Trigger (second generation)
; ───────────────────────────────────────────────────────────────────────────────
{.wind_at_location}
measurement_latitude = #:(-90..90)           ; Latitude of wind measurement location
measurement_longitude = #:(-180..180)        ; Longitude of wind measurement location
measurement_address = :                      ; Address of wind measurement location
wind_data_source = (jtwc, noaa_nhc, rms_hwind)  ; Source for wind data
measurement_type = (gust, sustained_1min, sustained_10min)  ; Type of wind measurement

{@hurricane_parametric}

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Configuration
; ───────────────────────────────────────────────────────────────────────────────
trigger = @parametric_trigger                ; Reference to trigger definition

; ───────────────────────────────────────────────────────────────────────────────
; Payout Structure
; ───────────────────────────────────────────────────────────────────────────────
payout_structure = @parametric_payout_structure  ; Reference to payout structure

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Period
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                        ; Coverage effective date
expiration_date = date                       ; Coverage expiration date
:invariant expiration_date > effective_date

; Hurricane season (if applicable)
season_start = :                          ; e.g., "June 1"
season_end = :                            ; e.g., "November 30"

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
amount = #$:(0..)                            ; Premium amount
rate_on_line = #:(0..100)                    ; Premium as percentage of limit

{@hurricane_parametric}

; ═══════════════════════════════════════════════════════════════════════════════
; Catastrophe Bond (CAT Bond)
; ═══════════════════════════════════════════════════════════════════════════════
; Capital markets risk transfer instrument with parametric or modeled triggers.

{@cat_bond}
bond_id = :                                  ; Unique identifier for catastrophe bond

; ───────────────────────────────────────────────────────────────────────────────
; Bond Identification
; ───────────────────────────────────────────────────────────────────────────────
bond_name = :                                ; Name of catastrophe bond
cusip = :(9)                                 ; CUSIP identifier
isin = :(12)                                 ; ISIN identifier
series = :                                   ; Bond series
issue_date = date                            ; Bond issue date
maturity_date = date                         ; Bond maturity date
:invariant maturity_date > issue_date

; ───────────────────────────────────────────────────────────────────────────────
; Parties
; ───────────────────────────────────────────────────────────────────────────────
; Sponsor (cedent seeking protection)
{.sponsor}
name = :                                     ; Sponsor name
type = (corporation, government, insurer, reinsurer)  ; Sponsor type
rating = :                                   ; Credit rating
country = :(2..3)                            ; Sponsor country code

{@cat_bond}

; Special Purpose Vehicle
{.spv}
name = :                                     ; SPV name
domicile = :(2..3)                              ; BM, KY, IE common
registration_number = :                      ; SPV registration number

{@cat_bond}

; Investors (capital providers)
{.investors}
investor_class[] = (
    asset_manager,
    family_office,
    hedge_fund,
    ils_fund,
    pension_fund,
    reinsurer,
    sovereign_wealth
)                                            ; Types of investors
minimum_investment = #$:(0..)                ; Minimum investment amount

{@cat_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Financial Terms
; ───────────────────────────────────────────────────────────────────────────────
{.terms}
; Principal
principal_at_risk = #$:(0..)                 ; Principal amount at risk
currency = :(3) "USD"                        ; Currency code

; Coupon
coupon_type = (fixed, floating)              ; Type of coupon payment
coupon_rate = #:(0..50)                         ; Annual coupon rate %
coupon_spread = #:(0..30)                       ; Spread over SOFR/reference rate
coupon_frequency = (annual, monthly, quarterly, semi_annual)  ; Coupon payment frequency
reference_rate = (other, sofr, t_bill)       ; Reference rate for floating coupon

; Collateral
collateral_type = (money_market, t_bills, tri_party_repo)  ; Type of collateral
collateral_account = :                       ; Collateral account identifier

{@cat_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Structure
; ───────────────────────────────────────────────────────────────────────────────
trigger_type = (
    hybrid,                                     ; Combination of trigger types
    indemnity,                                  ; Sponsor's actual losses
    industry_loss,                              ; PCS/industry index
    modeled_loss,                               ; Catastrophe model output
    parametric                                  ; Index-based (magnitude, wind, etc.)
)

; Parametric Trigger (if applicable)
parametric_trigger = @parametric_trigger:if trigger_type = parametric  ; Reference to parametric trigger

; Industry Loss Trigger (if applicable)
{.industry_loss_trigger}
index_provider = (munichre_natcat, pcs, perils, sigma):if trigger_type = industry_loss  ; Index provider
attachment_point = #$:(0..):if trigger_type = industry_loss  ; Attachment point amount
exhaustion_point = #$:(0..):if trigger_type = industry_loss  ; Exhaustion point amount
occurrence_or_aggregate = (aggregate, occurrence):if trigger_type = industry_loss  ; Occurrence or aggregate basis

{@cat_bond}

; Modeled Loss Trigger (if applicable)
{.modeled_loss_trigger}
model_provider = (air, corelogic, other, rms):if trigger_type = modeled_loss  ; Catastrophe model provider
model_version = ::if trigger_type = modeled_loss  ; Model version
attachment_loss = #$:(0..):if trigger_type = modeled_loss  ; Attachment loss amount
exhaustion_loss = #$:(0..):if trigger_type = modeled_loss  ; Exhaustion loss amount

{@cat_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Perils
; ───────────────────────────────────────────────────────────────────────────────
covered_perils[] = (
    earthquake,
    european_windstorm,
    flood,
    hail,
    hurricane,
    multi_peril,
    pandemic,
    severe_convective_storm,
    terrorism,
    tornado,
    tsunami,
    typhoon,
    volcanic_eruption,
    wildfire,
    winter_storm
)

; ───────────────────────────────────────────────────────────────────────────────
; Geographic Coverage
; ───────────────────────────────────────────────────────────────────────────────
covered_regions[] = @parametric_geographic_scope  ; Array of covered geographic regions
primary_region = :                           ; Primary region description

; ───────────────────────────────────────────────────────────────────────────────
; Tranche Structure
; ───────────────────────────────────────────────────────────────────────────────
{.tranches[]}
tranche_id = :                               ; Tranche identifier
tranche_name = :                             ; Tranche name
principal = #$:(0..)                         ; Principal amount
attachment_probability = #:(0..100)             ; Probability of first loss
expected_loss = #:(0..100)                      ; Annual expected loss %
coupon_spread = #:(0..30)                    ; Coupon spread over reference rate
rating = :                                ; S&P/Moody's rating
subordination = #:(0..100)                      ; % of structure below this tranche

{@cat_bond}

; ───────────────────────────────────────────────────────────────────────────────
; Payout Structure
; ───────────────────────────────────────────────────────────────────────────────
payout_structure = @parametric_payout_structure  ; Reference to payout structure

; ───────────────────────────────────────────────────────────────────────────────
; Reset Provisions
; ───────────────────────────────────────────────────────────────────────────────
{.reset}
resettable = ?                               ; Whether bond can reset
reset_frequency = (annual, semi_annual):if reset.resettable = true  ; Frequency of resets
attachment_reset = ?:if reset.resettable = true  ; Whether attachment point resets
exhaustion_reset = ?:if reset.resettable = true  ; Whether exhaustion point resets

{@cat_bond}

; ═══════════════════════════════════════════════════════════════════════════════
; Industry Loss Warranty (ILW)
; ═══════════════════════════════════════════════════════════════════════════════
; Reinsurance contract triggered by industry-wide loss index.

{@industry_loss_warranty}
ilw_id = :                                   ; Unique identifier for ILW

; ───────────────────────────────────────────────────────────────────────────────
; Contract Identification
; ───────────────────────────────────────────────────────────────────────────────
contract_reference = :                       ; Contract reference number
effective_date = date                        ; Contract effective date
expiration_date = date                       ; Contract expiration date
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Contract Type
; ───────────────────────────────────────────────────────────────────────────────
contract_form = (
    binary,                                     ; Full limit when trigger is hit
    pro_rata                                    ; Proportional payout
)

occurrence_type = (
    aggregate,                                  ; Sum of qualifying events
    first_event,                                ; First qualifying event only
    per_occurrence,                             ; Each qualifying event
    second_event                                ; Second qualifying event only
)

; ───────────────────────────────────────────────────────────────────────────────
; Industry Loss Trigger
; ───────────────────────────────────────────────────────────────────────────────
{.trigger}
; Index Provider
index_provider = (munichre_natcat, pcs, perils, sigma)  ; Industry loss index provider
index_region = :                         ; e.g., "US", "Europe", "Japan"

; Attachment (trigger threshold)
attachment_point = #$:(0..)                    ; Industry loss level to trigger
exhaustion_point = #$:(0..)                     ; Full payout level

; Currency
currency = :(3) "USD"                        ; Currency code

; Development Period
loss_development_period_months = ##    ; Time to finalize loss estimate

{@industry_loss_warranty}

; ───────────────────────────────────────────────────────────────────────────────
; Covered Perils
; ───────────────────────────────────────────────────────────────────────────────
covered_perils[] = (
    all_natural_perils,
    earthquake,
    european_windstorm,
    flood,
    named_storm,
    severe_convective_storm,
    terrorism,
    tropical_cyclone,
    wildfire,
    winter_storm
)

; ───────────────────────────────────────────────────────────────────────────────
; Territory
; ───────────────────────────────────────────────────────────────────────────────
covered_territory = @parametric_geographic_scope  ; Geographic territory covered

; ───────────────────────────────────────────────────────────────────────────────
; Limit and Premium
; ───────────────────────────────────────────────────────────────────────────────
limit = #$:(0..)                             ; Coverage limit
rate_on_line = #:(0..100)                       ; Premium as % of limit
premium = #$:(0..)                           ; Premium amount

; ───────────────────────────────────────────────────────────────────────────────
; Warranty
; ───────────────────────────────────────────────────────────────────────────────
; The "warranty" component - cedent must have actual loss
{.warranty}
cedent_loss_warranty = ?                        ; Cedent must have qualifying loss
cedent_loss_minimum = #$:(0..)                  ; Minimum cedent loss
cedent_loss_proof_required = ?               ; Whether proof of loss is required

{@industry_loss_warranty}

; ───────────────────────────────────────────────────────────────────────────────
; Settlement
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
settlement_period_days = ##                  ; Settlement period in days
interim_payment_available = ?                ; Whether interim payments are available
interim_payment_percentage = ##:(0..100):if settlement.interim_payment_available = true  ; Interim payment percentage

{@industry_loss_warranty}

; ═══════════════════════════════════════════════════════════════════════════════
; Basis Risk Assessment
; ═══════════════════════════════════════════════════════════════════════════════
; Documents the basis risk - difference between parametric payout and actual loss.

{@basis_risk_assessment}
assessment_id = :                            ; Unique identifier for basis risk assessment

; ───────────────────────────────────────────────────────────────────────────────
; Basis Risk Type
; ───────────────────────────────────────────────────────────────────────────────
basis_risk_type = (
    design,                                     ; Trigger design doesn't match exposure
    geographic,                                 ; Location mismatch (weather station vs. risk)
    index_correlation,                          ; Poor correlation between index and loss
    temporal                                    ; Timing mismatch
)

; ───────────────────────────────────────────────────────────────────────────────
; Risk Metrics
; ───────────────────────────────────────────────────────────────────────────────
{.metrics}
; Correlation Analysis
historical_correlation = #:(0..1)               ; Correlation coefficient
r_squared = #:(0..1)                            ; R-squared goodness of fit

; Shortfall Risk
expected_shortfall_pct = #:(0..100)             ; Expected underpayment %
probability_of_shortfall = #:(0..100)           ; Probability payout < loss

; Overpayment Risk
expected_overpayment_pct = #:(0..100)           ; Expected overpayment %
probability_of_overpayment = #:(0..100)         ; Probability payout > loss

{@basis_risk_assessment}

; ───────────────────────────────────────────────────────────────────────────────
; Mitigation Strategies
; ───────────────────────────────────────────────────────────────────────────────
{.mitigation}
strategies[] = (
    blended_indemnity,                          ; Combine with traditional cover
    multi_trigger,                              ; Use multiple index parameters
    second_generation_trigger,                  ; Use location-specific measurement
    sublimit_parametric                         ; Use as sublimit within larger program
)                                            ; Array of mitigation strategies
mitigation_description = :                   ; Description of mitigation approach

{@basis_risk_assessment}

; ═══════════════════════════════════════════════════════════════════════════════
; Parametric Event Record
; ═══════════════════════════════════════════════════════════════════════════════
; Records a triggered event and the resulting payout calculation.

{@parametric_event}
event_id = :                                 ; Unique identifier for parametric event

; ───────────────────────────────────────────────────────────────────────────────
; Event Identification
; ───────────────────────────────────────────────────────────────────────────────
event_name = :                           ; e.g., "Hurricane Milton", "M6.5 Napa Earthquake"
event_type = (drought, earthquake, flood, freeze, hail, hurricane, other, tornado, wildfire, wind)  ; Type of event
event_date = date                            ; Event date
event_timestamp = timestamp                  ; Event timestamp

; ───────────────────────────────────────────────────────────────────────────────
; Measured Values
; ───────────────────────────────────────────────────────────────────────────────
{.measurement}
parameter = :                            ; What was measured
measured_value = #                           ; Value that was measured
measurement_unit = :                         ; Unit of measurement
measurement_timestamp = timestamp            ; When measurement was taken
measurement_location = :                     ; Where measurement was taken
data_source_reference = :                ; URL or reference to official data

{@parametric_event}

; ───────────────────────────────────────────────────────────────────────────────
; Trigger Evaluation
; ───────────────────────────────────────────────────────────────────────────────
{.evaluation}
trigger_id = :                               ; Reference to trigger that was evaluated
threshold_value = #                          ; Threshold value for comparison
threshold_met = ?                            ; Whether threshold was met
margin_over_threshold = #                       ; How much above/below trigger
margin_percentage = #                 ; % above threshold

{@parametric_event}

; ───────────────────────────────────────────────────────────────────────────────
; Payout Calculation
; ───────────────────────────────────────────────────────────────────────────────
{.payout}
payout_triggered = ?                         ; Whether payout was triggered
payout_tier = :                              ; Payout tier if applicable
payout_percentage = ##:(0..100)              ; Payout percentage
calculated_payout = #$:(0..)                 ; Calculated payout amount
actual_payout = #$:(0..)                     ; Actual payout amount
payout_date = date                           ; Date of payout

{@parametric_event}

; ───────────────────────────────────────────────────────────────────────────────
; Basis Risk Outcome
; ───────────────────────────────────────────────────────────────────────────────
{.basis_risk_outcome}
estimated_actual_loss = #$:(0..)             ; Estimated actual loss amount
payout_vs_loss_difference = #$               ; Difference between payout and actual loss
shortfall = ?                                   ; Payout < actual loss
shortfall_amount = #$:(0..):if basis_risk_outcome.shortfall = true  ; Amount of shortfall
overpayment = ?                                 ; Payout > actual loss
overpayment_amount = #$:(0..):if basis_risk_outcome.overpayment = true  ; Amount of overpayment

{@parametric_event}

; ═══════════════════════════════════════════════════════════════════════════════
; Parametric Policy
; ═══════════════════════════════════════════════════════════════════════════════
; Main wrapper type composing all parametric coverage components.

{@parametric_policy}
id = :                                       ; Policy identifier
number = :                                   ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Policy Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                        ; Policy effective date
effective_time = time                        ; Policy effective time
expiration_date = date                       ; Policy expiration date
expiration_time = time                       ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
type = (
    blended,                                    ; Combined parametric + indemnity
    cat_bond,                                   ; Catastrophe bond
    ilw,                                        ; Industry Loss Warranty
    parametric_excess,                          ; Excess layer parametric
    parametric_primary,                         ; Primary parametric coverage
    weather_derivative                          ; Weather derivative contract
)

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured / Cedent
; ───────────────────────────────────────────────────────────────────────────────
{.insured}
name = :                                     ; Insured party name
type = (corporation, government, individual, insurer, reinsurer)  ; Insured party type
address = @types.address                     ; Insured party address
contact = @types.contact_info                ; Insured party contact information

{@parametric_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Components
; ───────────────────────────────────────────────────────────────────────────────
weather_coverages[] = @weather_parametric    ; Array of weather parametric coverages
earthquake_coverages[] = @earthquake_parametric  ; Array of earthquake parametric coverages
hurricane_coverages[] = @hurricane_parametric  ; Array of hurricane parametric coverages
cat_bond = @cat_bond                         ; Catastrophe bond if applicable
ilw = @industry_loss_warranty                ; Industry loss warranty if applicable

; ───────────────────────────────────────────────────────────────────────────────
; Aggregate Limits
; ───────────────────────────────────────────────────────────────────────────────
{.limits}
per_event = #$:(0..)                         ; Limit per event
annual_aggregate = #$:(0..)                  ; Annual aggregate limit
policy_aggregate = #$:(0..)                  ; Total policy aggregate limit
maximum_per_trigger = #$:(0..)               ; Maximum payout per trigger

{@parametric_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Premium
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
base = #$:(0..)                              ; Base premium amount
rate_on_line = #:(0..100)                    ; Rate on line percentage
taxes_fees = #$:(0..)                        ; Taxes and fees
total = #$:(0..)                             ; Total premium

{@parametric_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Events and Claims
; ───────────────────────────────────────────────────────────────────────────────
events[] = @parametric_event                 ; Array of parametric events

; ───────────────────────────────────────────────────────────────────────────────
; Basis Risk Assessment
; ───────────────────────────────────────────────────────────────────────────────
basis_risk_assessment = @basis_risk_assessment  ; Basis risk assessment for policy

; ───────────────────────────────────────────────────────────────────────────────
; Data Sources
; ───────────────────────────────────────────────────────────────────────────────
data_sources[] = @parametric_data_source     ; Array of data sources used

; ───────────────────────────────────────────────────────────────────────────────
; Settlement Terms
; ───────────────────────────────────────────────────────────────────────────────
{.settlement}
settlement_currency = :(3) "USD"             ; Settlement currency code
settlement_period_days = ##                  ; Settlement period in days
automatic_settlement = ?                        ; Auto-pay when trigger verified
dispute_resolution = (arbitration, court, expert_determination)  ; Dispute resolution method

{@parametric_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Blockchain/Smart Contract (if applicable)
; ───────────────────────────────────────────────────────────────────────────────
{.smart_contract}
enabled = ?                                  ; Whether smart contract is enabled
platform = (corda, ethereum, hyperledger, other, polygon):if smart_contract.enabled = true  ; Blockchain platform
contract_address = ::if smart_contract.enabled = true  ; Smart contract address
oracle_provider = (api3, chainlink, custom):if smart_contract.enabled = true  ; Oracle provider for data feeds

{@parametric_policy}


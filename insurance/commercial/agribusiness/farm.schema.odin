; ═══════════════════════════════════════════════════════════════════════════════
; ODIN Farm and Agribusiness Insurance Schema
; ═══════════════════════════════════════════════════════════════════════════════
; Farm and agricultural insurance covering farm property, farm liability, crop
; insurance (MPCI, crop-hail, revenue/yield protection), livestock coverage,
; and agricultural equipment for farming operations.
; ═══════════════════════════════════════════════════════════════════════════════

@import "../../coverages/coverage.schema.odin" as cov
@import "../../coverages/lines/property.schema.odin" as property
@import "../../coverages/lines/liability.schema.odin" as liability
@import "../../common/types.schema.odin" as com
@import "../business.schema.odin" as entity
@import "../business-location.schema.odin" as location

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.commercial.agribusiness.farm"
version = "1.0.0"
title = "Farm and Agribusiness Insurance Schema"
description = "Comprehensive farm coverage for property, liability, crops, and livestock"

{$derivation}
source[0].authority = "U.S. Department of Agriculture"
source[0].citation = "Risk Management Agency - Federal Crop Insurance"
source[0].url = "https://www.rma.usda.gov/"

source[1].authority = "U.S. Department of Agriculture"
source[1].citation = "National Agricultural Statistics Service"
source[1].url = "https://www.nass.usda.gov/"

source[2].authority = "Occupational Safety and Health Administration"
source[2].citation = "Agricultural Operations - 29 CFR 1928"
source[2].url = "https://www.osha.gov/agricultural-operations"

source[3].authority = "U.S. Environmental Protection Agency"
source[3].citation = "Agriculture Laws and Regulations"
source[3].url = "https://www.epa.gov/agriculture/laws-and-regulations-apply-your-agricultural-operation-farm-activity"

source[4].authority = "Agriculture and Agri-Food Canada"
source[4].citation = "Farm Insurance Programs"
source[4].url = "https://agriculture.canada.ca/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Farm schema based on USDA RMA requirements and agricultural regulations"

changelog[0].date = 2025-12-14
changelog[0].change = "Initial farm and agribusiness schema"
changelog[0].rationale = "Complete agricultural coverage including property, liability, crops, livestock"

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Operation
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_operation}
id = :                                            ; Unique identifier for farm operation

; ───────────────────────────────────────────────────────────────────────────────
; Farm Classification
; ───────────────────────────────────────────────────────────────────────────────
farm_type = (
    agritourism,
    aquaculture,
    christmas_tree,
    dairy,
    feedlot,
    fruit_orchard,
    grain,
    greenhouse_nursery,
    hobby_farm,
    horse_farm,
    livestock_breeding,
    livestock_ranching,
    mixed,
    organic,
    poultry,
    specialty_crop,
    timber,
    truck_farm_vegetables,
    vineyard_winery
)                                                 ; Type of farm operation

primary_activity = :                              ; Primary farming activity description
secondary_activities[] = :                        ; Additional farming activities conducted

; ───────────────────────────────────────────────────────────────────────────────
; Acreage
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
total_acres = ##                                  ; Total farm acreage
owned_acres = ##                                  ; Acres owned by farmer
leased_acres = ##                                 ; Acres leased by farmer
rented_to_others = ##                             ; Acres rented out to other farmers
cropland_acres = ##                               ; Acres used for crop production
pasture_acres = ##                                ; Acres used for pasture/grazing
woodland_acres = ##                               ; Acres of woodland/timber
farmstead_acres = ##                              ; Acres occupied by farm buildings/facilities
irrigated_acres = ##                              ; Acres with irrigation systems

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Revenue
; ───────────────────────────────────────────────────────────────────────────────
{.revenue}
annual_gross_farm_income = #$:(0..)               ; Total gross farm income per year
crop_sales = #$:(0..)                             ; Revenue from crop sales
livestock_sales = #$:(0..)                        ; Revenue from livestock sales
dairy_sales = #$:(0..)                            ; Revenue from dairy products
custom_farming_income = #$:(0..)                  ; Income from custom farming services
agritourism_income = #$:(0..)                     ; Revenue from agritourism activities
timber_sales = #$:(0..)                           ; Revenue from timber harvesting
other_farm_income = #$:(0..)                      ; Other farm-related income
non_farm_income = #$:(0..)                        ; Non-farm income sources

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Farm Labor
; ───────────────────────────────────────────────────────────────────────────────
{.labor}
family_members_working = ##                       ; Number of family members working on farm
full_time_hired = ##                              ; Number of full-time hired employees
part_time_hired = ##                              ; Number of part-time hired employees
seasonal_hired = ##                               ; Number of seasonal workers
migrant_workers = ##                              ; Number of migrant workers employed
annual_farm_payroll = #$:(0..)                    ; Total annual payroll for hired workers

; Workers Compensation
workers_comp_required = ?                         ; Whether workers compensation is required
workers_comp_policy = ::if workers_comp_required = true ; Workers compensation policy number

{@farm_operation}

; ───────────────────────────────────────────────────────────────────────────────
; Operations
; ───────────────────────────────────────────────────────────────────────────────
{.operations}
; Farming Activities
custom_farming_for_hire = ?                       ; Whether custom farming services offered
custom_harvesting = ?                             ; Whether custom harvesting services offered
custom_planting = ?                               ; Whether custom planting services offered
custom_spraying = ?                               ; Whether custom spraying services offered
contract_farming = ?                              ; Whether contract farming performed
organic_certified = ?                             ; Whether farm is organic certified
organic_certifier = ::if organic_certified = true ; Name of organic certifying organization

; Agritourism Activities
agritourism_operations = ?                        ; Whether farm has agritourism activities
farm_tours = ?:if agritourism_operations = true   ; Whether farm tours offered
u_pick = ?:if agritourism_operations = true       ; Whether u-pick operations offered
corn_maze = ?:if agritourism_operations = true    ; Whether corn maze attraction operated
pumpkin_patch = ?:if agritourism_operations = true ; Whether pumpkin patch operated
hay_rides = ?:if agritourism_operations = true    ; Whether hay rides offered
petting_zoo = ?:if agritourism_operations = true  ; Whether petting zoo operated
farm_stay = ?:if agritourism_operations = true    ; Whether farm stay accommodations offered
weddings_events = ?:if agritourism_operations = true ; Whether farm hosts weddings/events
farm_market = ?:if agritourism_operations = true  ; Whether farm market operated
farm_market_annual_sales = #$:(0..):if farm_market = true ; Annual sales from farm market
agritourism_visitors_annual = ##:if agritourism_operations = true ; Number of annual agritourism visitors

; Processing
on_farm_processing = ?                            ; Whether on-farm processing performed
processing_type = (
    cheese_dairy,
    grain_milling,
    meat_processing,
    produce_packing,
    wine_production
):if on_farm_processing = true                    ; Type of on-farm processing

; Hunting/Recreation
hunting_leases = ?                                ; Whether hunting leases offered
hunting_lease_income = #$:(0..):if hunting_leases = true ; Annual income from hunting leases
fishing_leases = ?                                ; Whether fishing leases offered

{@farm_operation}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Location
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_location}
id = :                                            ; Unique identifier for farm location
sequence = ##                                     ; Sequence number for ordering locations

; Address
location = @location.business_location           ; Reference to business location data

county = :                                        ; County where location is situated
township = :                                      ; Township legal description
range = :                                         ; Range legal description
section = :                                       ; Section legal description
parcel_number = :                                 ; Tax parcel identification number
latitude = #:(-90..90)                            ; Geographic latitude coordinate
longitude = #:(-180..180)                         ; Geographic longitude coordinate

; ───────────────────────────────────────────────────────────────────────────────
; Fire Protection
; ───────────────────────────────────────────────────────────────────────────────
fire_district = :                                 ; Fire protection district name
distance_to_fire_station_miles = #:(0..100)       ; Distance to nearest fire station in miles
fire_station_type = (full_time, none, volunteer)  ; Type of fire station serving location
water_supply = (hydrant, none, pond_lake, pressurized, well) ; Available water supply for firefighting
fire_extinguishers = ?                            ; Whether fire extinguishers present

; Protection Class
protection_class = ##                             ; ISO fire protection class rating

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Dwelling
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_dwelling}
id = :                                            ; Unique identifier for farm dwelling
location_ref = :                                  ; Reference to @farm_location.id
sequence = ##                                     ; Sequence number for ordering dwellings

; ───────────────────────────────────────────────────────────────────────────────
; Occupancy
; ───────────────────────────────────────────────────────────────────────────────
occupancy = (
    family_occupied,
    farm_labor_housing,
    tenant_occupied,
    vacant
)                                                 ; Type of dwelling occupancy

owner_occupied = ?                                ; Whether occupied by farm owner
principal_residence = ?                           ; Whether this is principal residence

; ───────────────────────────────────────────────────────────────────────────────
; Construction
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
year_built = ##:(1600..2100)                      ; Year dwelling was built
construction_type = (brick, frame, log, masonry, metal, stone) ; Primary construction type
exterior_wall = :                                 ; Exterior wall material description
stories = #:(1..5)                                ; Number of stories
square_feet = ##                                  ; Total square footage
foundation_type = (basement, crawl_space, pier, slab) ; Type of foundation
roof_type = (asphalt_shingle, metal, other, slate, tile, wood_shake) ; Type of roof covering
roof_age = ##:(0..100)                            ; Age of roof in years
electrical_update_year = ##:(1900..2100)          ; Year electrical system last updated
plumbing_update_year = ##:(1900..2100)            ; Year plumbing system last updated
heating_type = (electric, gas, oil, propane, wood) ; Type of heating system
heating_update_year = ##:(1900..2100)             ; Year heating system last updated

{@farm_dwelling}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
replacement_cost = #$:(0..)                       ; Cost to replace with new construction
actual_cash_value = #$:(0..)                      ; Depreciated replacement cost value
market_value = #$:(0..)                           ; Current market value

{@farm_dwelling}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Building / Structure
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_building}
id = :                                            ; Unique identifier for farm building
location_ref = :                                  ; Reference to @farm_location.id
sequence = ##:(1..)                               ; Sequence number for ordering buildings

; ───────────────────────────────────────────────────────────────────────────────
; Building Type
; ───────────────────────────────────────────────────────────────────────────────
building_type = (
    barn,
    bin_silo,
    bunkhouse,
    commodity_shed,
    dairy_parlor,
    equipment_shed,
    farrowing_house,
    feedlot_facility,
    grain_bin,
    grain_dryer,
    grain_elevator,
    greenhouse,
    hay_storage,
    hog_confinement,
    hoop_building,
    horse_barn,
    implement_shed,
    irrigation_facility,
    loafing_shed,
    machine_shop,
    milk_house,
    nursery,
    other,
    pole_barn,
    poultry_house,
    pump_house,
    seed_storage,
    shop,
    silo,
    slurry_storage,
    storage_building,
    utility_building,
    workshop
)                                                 ; Type of farm building or structure
building_description = :                          ; Detailed building description

; ───────────────────────────────────────────────────────────────────────────────
; Construction
; ───────────────────────────────────────────────────────────────────────────────
{.construction}
year_built = ##:(1800..2100)                      ; Year building was built
construction_type = (
    frame,
    masonry,
    metal,
    pole_frame,
    wood_frame
)                                                 ; Primary construction type
exterior_material = (aluminum, brick, concrete, metal, stone, wood) ; Exterior wall material
roof_type = (asphalt, built_up, metal, other, rubber) ; Type of roof covering
floor_type = (concrete, dirt, gravel, wood)       ; Type of floor
square_feet = ##                                  ; Total square footage
height_feet = ##                                  ; Building height in feet
stories = ##:(1..5)                               ; Number of stories
bay_count = ##                                    ; Number of bays or sections

{@farm_building}

; ───────────────────────────────────────────────────────────────────────────────
; Use
; ───────────────────────────────────────────────────────────────────────────────
{.use}
primary_use = :                                   ; Primary use description
current_use = (
    crop_storage,
    equipment_storage,
    livestock_housing,
    mixed,
    processing,
    vacant,
    workshop
)                                                 ; Current use classification
livestock_housed = ?                              ; Whether livestock housed in building
livestock_type = ::if livestock_housed = true     ; Type of livestock housed
livestock_capacity = ##:if livestock_housed = true ; Maximum livestock capacity
hazardous_storage = ?                             ; Whether hazardous materials stored
hazardous_materials[] = ::if hazardous_storage = true ; List of hazardous materials stored

{@farm_building}

; ───────────────────────────────────────────────────────────────────────────────
; Systems
; ───────────────────────────────────────────────────────────────────────────────
{.systems}
electrical = ?                                    ; Whether building has electrical service
electrical_amps = ##:if electrical = true         ; Electrical service amperage
heating = ?                                       ; Whether building has heating system
heating_type = (electric, gas, none, oil, propane, wood):if heating = true ; Type of heating system
ventilation = ?                                   ; Whether building has ventilation system
ventilation_type = (forced_air, natural, tunnel):if ventilation = true ; Type of ventilation system
water = ?                                         ; Whether building has water supply
fire_sprinklers = ?                               ; Whether fire sprinkler system present
fire_alarm = ?                                    ; Whether fire alarm system present

{@farm_building}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
replacement_cost = #$:(0..)                       ; Cost to replace with new construction
actual_cash_value = #$:(0..)                      ; Depreciated replacement cost value
functional_replacement = #$:(0..)                 ; Cost to replace with functionally equivalent building
agreed_value = #$:(0..)                           ; Agreed value for insurance purposes

{@farm_building}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Equipment / Machinery
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_equipment}
id = :                                            ; Unique identifier for equipment
sequence = ##:(1..)                               ; Sequence number for ordering equipment

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
description = :                                   ; Equipment description
manufacturer = :                                  ; Manufacturer name
model = :                                         ; Model number or name
serial_number = :                                 ; Serial number
year = ##:(1900..2100)                            ; Year manufactured

; Equipment Type
equipment_type = (
    air_seeder,
    anhydrous_applicator,
    atv_utv,
    auger,
    baler_round,
    baler_square,
    chisel_plow,
    combine,
    cotton_picker,
    crawler,
    cultivator,
    disc,
    farm_truck,
    feed_mixer,
    feed_wagon,
    fertilizer_spreader,
    field_cultivator,
    forage_harvester,
    front_loader,
    garden_tractor,
    generator,
    grain_cart,
    grain_drill,
    grain_dryer,
    grain_handling,
    grain_truck,
    hay_rake,
    irrigation_equipment,
    livestock_trailer,
    loader,
    manure_spreader,
    milking_equipment,
    mixer_wagon,
    moldboard_plow,
    mower_conditioner,
    other,
    picker,
    planter,
    precision_ag,
    ripper,
    rotary_tiller,
    row_crop_tractor,
    seed_tender,
    semi_truck,
    service_truck,
    skid_steer,
    skid_steer_attachment,
    sprayer,
    swather,
    telehandler,
    track_tractor,
    transplanter,
    utility_tractor,
    wheel_tractor,
    windrower
)                                                 ; Type of farm equipment

; ───────────────────────────────────────────────────────────────────────────────
; Specifications
; ───────────────────────────────────────────────────────────────────────────────
{.specifications}
horsepower = ##                                   ; Engine horsepower rating
pto_horsepower = ##                               ; Power take-off horsepower rating
engine_hours = ##                                 ; Total engine hours
capacity_bushels = ##                             ; Capacity in bushels (grain equipment)
width_feet = #                                    ; Working width in feet
weight_lbs = ##                                   ; Equipment weight in pounds

{@farm_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.ownership}
owned = ?                                         ; Whether equipment is owned
leased = ?                                        ; Whether equipment is leased
leased_from = ::if leased = true                  ; Lessor name if leased
custom_operator_owned = ?                         ; Whether owned by custom operator

{@farm_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
purchase_price = #$:(0..)                         ; Original purchase price
purchase_date = date                              ; Date of purchase
replacement_cost = #$:(0..)                       ; Cost to replace with new
actual_cash_value = #$:(0..)                      ; Depreciated value
agreed_value = #$:(0..)                           ; Agreed value for insurance purposes

{@farm_equipment}

; ───────────────────────────────────────────────────────────────────────────────
; Location/Use
; ───────────────────────────────────────────────────────────────────────────────
{.use}
location_ref = :                                  ; Reference to @farm_location.id
seasonal_use = ?                                  ; Whether equipment used seasonally
months_used = ##:(1..12)                          ; Number of months used per year
off_premises_use = ?                              ; Whether used off farm premises
custom_work_for_hire = ?                          ; Whether used for custom hire work
leased_to_others = ?                              ; Whether leased/rented to others

{@farm_equipment}

; ═══════════════════════════════════════════════════════════════════════════════
; Livestock (Blanket - Groups)
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_livestock}
id = :                                            ; Unique identifier for livestock group

; ───────────────────────────────────────────────────────────────────────────────
; Type and Count
; ───────────────────────────────────────────────────────────────────────────────
livestock_type = (
    beef_cattle,
    bees,
    bison,
    catfish_aquaculture,
    dairy_cattle,
    deer_elk,
    donkeys_mules,
    ducks,
    emus_ostriches,
    geese,
    goats_dairy,
    goats_meat,
    horses,
    llamas_alpacas,
    other,
    pigs_swine,
    poultry_broilers,
    poultry_layers,
    rabbits,
    sheep,
    turkeys
)                                                 ; Type of livestock

livestock_description = :                         ; Description of livestock group
head_count = ##                                   ; Number of animals in group
average_weight_lbs = ##                           ; Average weight per animal in pounds

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
; Cattle
beef_breed = (
    angus,
    brahman,
    charolais,
    hereford,
    limousin,
    mixed,
    other,
    simmental
):if livestock_type = beef_cattle                 ; Breed of beef cattle

dairy_breed = (
    brown_swiss,
    guernsey,
    holstein,
    jersey,
    mixed,
    other
):if livestock_type = dairy_cattle                ; Breed of dairy cattle

; Horses
horse_breed = ::if livestock_type = horses        ; Breed of horse
horse_use = (
    breeding,
    pleasure,
    racing,
    rodeo,
    show,
    working
):if livestock_type = horses                      ; Primary use of horses

; Age/Category
age_category = (
    breeding_stock,
    calves_under_1_year,
    feeder,
    finishing,
    heifers,
    mature,
    other,
    replacement,
    steers,
    yearlings
)                                                 ; Age/category classification
sex = (female, male, mixed)                       ; Sex composition of group

{@farm_livestock}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
total_value = #$:(0..)                            ; Total value of livestock group
per_head_value = #$:(0..)                         ; Value per animal
market_value = #$:(0..)                           ; Current market value
breeding_value = #$:(0..)                         ; Breeding stock value premium

{@farm_livestock}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
location_ref = :                                  ; Reference to @farm_location.id
housing_type = (barn, confinement, feedlot, open_range, other, pasture) ; Type of housing/containment

; ═══════════════════════════════════════════════════════════════════════════════
; Livestock Scheduled (Individual High-Value Animals)
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_livestock_scheduled}
id = :                                            ; Unique identifier for individual animal

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
name = :                                          ; Animal name (e.g. "Champion Thunder")
animal_type = (
    breeding_bull,
    breeding_stallion,
    broodmare,
    dairy_bull,
    other,
    show_animal,
    show_horse
)                                                 ; Type of individual animal
breed = :                                         ; Breed name
registration_number = :                           ; Breed registry number
tattoo = :                                        ; Tattoo identification
microchip = :                                     ; Microchip identification number
brand = :                                         ; Brand marking
date_of_birth = *date                             ; Animal's date of birth
sex = (female, male)                              ; Sex of animal
color_markings = :                                ; Color and marking description

; ───────────────────────────────────────────────────────────────────────────────
; Lineage (for breeding stock)
; ───────────────────────────────────────────────────────────────────────────────
{.lineage}
sire = :                                          ; Sire (father) name
sire_registration = :                             ; Sire registration number
dam = :                                           ; Dam (mother) name
dam_registration = :                              ; Dam registration number

{@farm_livestock_scheduled}

; ───────────────────────────────────────────────────────────────────────────────
; Valuation
; ───────────────────────────────────────────────────────────────────────────────
{.valuation}
agreed_value = #$:(0..)                           ; Agreed value for insurance purposes
purchase_price = #$:(0..)                         ; Original purchase price
purchase_date = date                              ; Date of purchase
appraisal_value = #$:(0..)                        ; Professional appraisal value
appraisal_date = date                             ; Date of appraisal

{@farm_livestock_scheduled}

; ───────────────────────────────────────────────────────────────────────────────
; Use
; ───────────────────────────────────────────────────────────────────────────────
primary_use = (breeding, dairy, pleasure, racing, rodeo, show, working) ; Primary use of animal
location_ref = :                                  ; Reference to @farm_location.id

; ═══════════════════════════════════════════════════════════════════════════════
; Crop Information
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_crop}
id = :                                            ; Unique identifier for crop
crop_year = ##:(2000..2100)                       ; Crop year

; ───────────────────────────────────────────────────────────────────────────────
; Crop Type
; ───────────────────────────────────────────────────────────────────────────────
crop_type = (
    alfalfa,
    apples,
    barley,
    blueberries,
    canola,
    cherries,
    citrus,
    corn_grain,
    corn_silage,
    cotton,
    dry_beans,
    grapes,
    hay,
    hemp,
    milo_sorghum,
    oats,
    onions,
    other,
    peaches,
    peanuts,
    pecans,
    peppers,
    potatoes,
    rice,
    rye,
    soybeans,
    strawberries,
    sugar_beets,
    sunflowers,
    tobacco,
    tomatoes,
    tree_nuts,
    vegetables_other,
    wheat_spring,
    wheat_winter
)                                                 ; Type of crop

crop_description = :                              ; Crop description
variety = :                                       ; Crop variety or cultivar
organic = ?                                       ; Whether crop is organically grown

; ───────────────────────────────────────────────────────────────────────────────
; Acreage
; ───────────────────────────────────────────────────────────────────────────────
{.acreage}
planted_acres = #                                 ; Acres planted
insured_acres = #                                 ; Acres insured
irrigated_acres = #                               ; Acres with irrigation
dryland_acres = #                                 ; Acres without irrigation (dryland)
share_percentage = ##:(0..100)                    ; Farmer's ownership share percentage

{@farm_crop}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
county = :                                        ; County where crop is located
state_province = :(2)                             ; US state or Canadian province code
township = :                                      ; Township legal description
section = :                                       ; Section legal description
legal_description = :                             ; Full legal description of land

; ───────────────────────────────────────────────────────────────────────────────
; Historical Yields
; ───────────────────────────────────────────────────────────────────────────────
{.yields}
aph_yield = #                                     ; Actual Production History yield
transitional_yield = #                            ; Transitional yield for new crops
county_expected_yield = #                         ; County average expected yield
approved_yield = #                                ; RMA approved yield for insurance
unit_type = (basic, enterprise, optional, whole_farm) ; Crop insurance unit type

{@farm_crop}

; ───────────────────────────────────────────────────────────────────────────────
; Coverage Election (Federal Crop Insurance)
; ───────────────────────────────────────────────────────────────────────────────
{.federal_coverage}
mpci_enrolled = ?                                 ; Multi-Peril Crop Insurance enrollment status
coverage_type = (
    area_revenue_protection,
    area_yield_protection,
    revenue_protection,
    revenue_protection_harvest_price_exclusion,
    yield_protection
):if mpci_enrolled = true                         ; Type of federal crop insurance coverage

coverage_level = ##:(50, 55, 60, 65, 70, 75, 80, 85):if mpci_enrolled = true ; Coverage level percentage
price_election = ##:(55..100):if mpci_enrolled = true ; Price election percentage
prevented_planting = ?:if mpci_enrolled = true    ; Prevented planting coverage included
replant_coverage = ?:if mpci_enrolled = true      ; Replant coverage included
written_agreement = ?:if mpci_enrolled = true     ; Written agreement in place

; Protection Amounts
projected_price = #$:(0..):if mpci_enrolled = true ; Projected price per unit
liability = #$:(0..):if mpci_enrolled = true      ; Total liability amount
premium = #$:(0..):if mpci_enrolled = true        ; Total premium amount
subsidy = #$:(0..):if mpci_enrolled = true        ; Federal subsidy amount
producer_premium = #$:(0..):if mpci_enrolled = true ; Producer's premium after subsidy

{@farm_crop}

; ───────────────────────────────────────────────────────────────────────────────
; Crop-Hail Coverage (Private)
; ───────────────────────────────────────────────────────────────────────────────
{.crop_hail}
included = ?                                      ; Whether crop-hail coverage included
coverage_per_acre = #$:(0..):if crop_hail.included = true ; Coverage amount per acre
deductible_percent = ##:(0, 5, 10, 15, 20, 25):if crop_hail.included = true ; Deductible percentage
fire_coverage = ?:if crop_hail.included = true    ; Fire coverage included
replant_coverage = ?:if crop_hail.included = true ; Replant coverage included
extra_harvest_expense = ?:if crop_hail.included = true ; Extra harvest expense coverage
premium = #$:(0..):if crop_hail.included = true   ; Crop-hail premium amount

{@farm_crop}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Property Coverage (Extends Property Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_dwelling_coverage}
= @property_coverage                              ; Inherit from property line

dwelling_ref = :                                  ; Reference to @farm_dwelling.id
other_structures_percent = ##:(0..100)            ; Other structures coverage as % of dwelling limit
personal_property_percent = ##:(0..100)           ; Personal property coverage as % of dwelling limit
loss_of_use_percent = ##:(0..100)                 ; Loss of use coverage as % of dwelling limit

{@farm_building_coverage}
= @property_coverage                              ; Inherit from property line

building_ref = :                                  ; Reference to @farm_building.id
blanket = ?                                       ; Whether building covered under blanket
blanket_number = ::if blanket = true              ; Blanket coverage group number

{@farm_equipment_coverage}
= @property_coverage                              ; Inherit from property line

equipment_ref = :                                 ; Reference to @farm_equipment.id (if scheduled)
scheduled = ?                                     ; Whether equipment is specifically scheduled
blanket = ?                                       ; Whether equipment covered under blanket
collision = ?                                     ; Collision coverage included
comprehensive = ?                                 ; Comprehensive coverage included
liability_while_operating = ?                     ; Liability coverage while operating

{@farm_livestock_coverage}
= @property_coverage                              ; Inherit from property line

livestock_ref = :                                 ; Reference to @farm_livestock.id or @farm_livestock_scheduled.id
scheduled = ?                                     ; Whether livestock is specifically scheduled
blanket = ?                                       ; Whether livestock covered under blanket

; ───────────────────────────────────────────────────────────────────────────────
; Mortality Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.mortality}
included = ?                                      ; Whether mortality coverage included
perils_covered = (
    accident,
    all_risk,
    disease,
    named_perils,
    theft
):if mortality.included = true                    ; Perils covered under mortality coverage

{@farm_livestock_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Theft Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.theft}
included = ?                                      ; Whether theft coverage included

{@farm_livestock_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Transit Coverage
; ───────────────────────────────────────────────────────────────────────────────
{.transit}
included = ?                                      ; Whether transit coverage included
radius_miles = ##:if transit.included = true      ; Coverage radius in miles

{@farm_livestock_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Liability Coverage (Extends Liability Coverage)
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_liability_coverage}
= @liability_coverage                             ; Inherit from liability line

; ───────────────────────────────────────────────────────────────────────────────
; Farm Operations Liability
; ───────────────────────────────────────────────────────────────────────────────
{.farm_operations}
included = ?                                      ; Whether farm operations liability included
custom_farming = ?:if farm_operations.included = true ; Custom farming operations covered
custom_farming_receipts = #$:(0..):if custom_farming = true ; Annual custom farming receipts
contract_farming = ?:if farm_operations.included = true ; Contract farming operations covered
farmers_market = ?:if farm_operations.included = true ; Farmers market operations covered

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Products Liability
; ───────────────────────────────────────────────────────────────────────────────
{.products}
included = ?                                      ; Whether products liability included
farm_products_sold = ?:if products.included = true ; Farm products sold to consumers
processing_operations = ?:if products.included = true ; On-farm processing operations
direct_to_consumer = ?:if products.included = true ; Direct-to-consumer sales

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Agritourism Liability
; ───────────────────────────────────────────────────────────────────────────────
{.agritourism}
included = ?                                      ; Whether agritourism liability included
activities_covered[] = (
    barn_tours,
    corn_maze,
    farm_dinners,
    farm_stay,
    hay_rides,
    petting_zoo,
    pumpkin_patch,
    u_pick,
    weddings_events
):if agritourism.included = true                  ; Agritourism activities covered
participant_waivers_required = ?:if agritourism.included = true ; Whether participant waivers required

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Employer Liability
; ───────────────────────────────────────────────────────────────────────────────
{.employers}
included = ?                                      ; Whether employer liability included

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Pollution Liability
; ───────────────────────────────────────────────────────────────────────────────
{.pollution}
included = ?                                      ; Whether pollution liability included
agricultural_chemicals = ?:if pollution.included = true ; Agricultural chemical coverage
fuel_storage = ?:if pollution.included = true     ; Fuel storage coverage
manure_lagoon = ?:if pollution.included = true    ; Manure lagoon coverage

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Animal Liability
; ───────────────────────────────────────────────────────────────────────────────
{.animal}
included = ?                                      ; Whether animal liability included
bulls_stallions_boars = ?:if animal.included = true ; Bulls, stallions, and boars covered
dogs = ?:if animal.included = true                ; Farm dogs covered
exotic_animals = ?:if animal.included = true      ; Exotic animals covered

{@farm_liability_coverage}

; ───────────────────────────────────────────────────────────────────────────────
; Exclusions
; ───────────────────────────────────────────────────────────────────────────────
{.exclusions}
aircraft = ?true                                  ; Aircraft operations excluded
autos = ?true                                     ; Auto liability excluded
pollution_standard = ?true                        ; Standard pollution exclusion
professional_services = ?true                     ; Professional services excluded
workers_compensation = ?true                      ; Workers compensation excluded
contractual = ?                                   ; Contractual liability exclusion
employee_benefits = ?                             ; Employee benefits liability exclusion
recall = ?                                        ; Product recall exclusion

{@farm_liability_coverage}

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Endorsement
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_endorsement}
id = :                                            ; Unique identifier for endorsement
number = :                                        ; Endorsement number
title = :                                         ; Endorsement title
effective_date = date                             ; Effective date of endorsement

; Endorsement Type
type = (
    additional_insured,
    agritourism_extension,
    blanket_coverage,
    building_addition,
    building_deletion,
    custom_farming,
    deductible_change,
    dwelling_addition,
    equipment_addition,
    equipment_deletion,
    liability_increase,
    livestock_addition,
    loss_payee,
    other,
    pollution_coverage,
    scheduled_property
)                                                 ; Type of endorsement

description = :                                   ; Endorsement description
premium_impact = #$                               ; Premium change from endorsement

; ═══════════════════════════════════════════════════════════════════════════════
; Farm Policy (Composes All Parts)
; ═══════════════════════════════════════════════════════════════════════════════

{@farm_policy}
id = :                                            ; Unique identifier for farm policy
number = :                                        ; Policy number

; ───────────────────────────────────────────────────────────────────────────────
; Term
; ───────────────────────────────────────────────────────────────────────────────
effective_date = date                             ; Policy effective date
effective_time = time                             ; Policy effective time
expiration_date = date                            ; Policy expiration date
expiration_time = time                            ; Policy expiration time
:invariant expiration_date > effective_date

; ───────────────────────────────────────────────────────────────────────────────
; Policy Type
; ───────────────────────────────────────────────────────────────────────────────
policy_form = (
    farm_liability_only,
    farm_owners,                                  ; Package policy
    farm_property_only,
    farmowners_estate,                            ; Large operations
    rural_property                                ; Rural residence, hobby farm
)                                                 ; Type of farm policy form

; ───────────────────────────────────────────────────────────────────────────────
; Named Insured
; ───────────────────────────────────────────────────────────────────────────────
named_insured = @entity.business                  ; Reference to named insured business entity
farm_operation = @farm_operation                  ; Reference to farm operation details

; ───────────────────────────────────────────────────────────────────────────────
; Locations
; ───────────────────────────────────────────────────────────────────────────────
locations[] = @farm_location                      ; Farm locations covered by policy

; ───────────────────────────────────────────────────────────────────────────────
; Property Items
; ───────────────────────────────────────────────────────────────────────────────
dwellings[] = @farm_dwelling                      ; Farm dwellings on policy
buildings[] = @farm_building                      ; Farm buildings on policy
scheduled_equipment[] = @farm_equipment           ; Scheduled farm equipment
livestock[] = @farm_livestock                     ; Blanket livestock groups
scheduled_livestock[] = @farm_livestock_scheduled ; Individually scheduled high-value livestock
crops[] = @farm_crop                              ; Crops insured on policy

; ───────────────────────────────────────────────────────────────────────────────
; Coverages
; ───────────────────────────────────────────────────────────────────────────────
dwelling_coverages[] = @farm_dwelling_coverage    ; Dwelling coverage details
building_coverages[] = @farm_building_coverage    ; Building coverage details
equipment_coverages[] = @farm_equipment_coverage  ; Equipment coverage details
livestock_coverages[] = @farm_livestock_coverage  ; Livestock coverage details
liability_coverage = @farm_liability_coverage     ; Farm liability coverage

; ───────────────────────────────────────────────────────────────────────────────
; Blanket Limits
; ───────────────────────────────────────────────────────────────────────────────
blanket_equipment_limit = #$:(0..)                ; Blanket limit for unscheduled equipment
blanket_livestock_limit = #$:(0..)                ; Blanket limit for unscheduled livestock

; ───────────────────────────────────────────────────────────────────────────────
; Stored Commodities
; ───────────────────────────────────────────────────────────────────────────────
{.commodities}
grain_stored = ?                                  ; Whether grain is stored on farm
grain_types[] = ::if grain_stored = true          ; Types of grain stored
grain_bushels = ##:if grain_stored = true         ; Quantity of grain in bushels
grain_value = #$:(0..):if grain_stored = true     ; Total value of stored grain

hay_stored = ?                                    ; Whether hay is stored on farm
hay_tons = ##:if hay_stored = true                ; Quantity of hay in tons
hay_value = #$:(0..):if hay_stored = true         ; Total value of stored hay

feed_stored = ?                                   ; Whether feed is stored on farm
feed_value = #$:(0..):if feed_stored = true       ; Total value of stored feed

seed_stored = ?                                   ; Whether seed is stored on farm
seed_value = #$:(0..):if seed_stored = true       ; Total value of stored seed

{@farm_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Medical Payments
; ───────────────────────────────────────────────────────────────────────────────
{.medical}
per_person = #$:(0..)                             ; Medical payments limit per person
per_accident = #$:(0..)                           ; Medical payments limit per accident

{@farm_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Endorsements
; ───────────────────────────────────────────────────────────────────────────────
endorsements[] = @farm_endorsement                ; Policy endorsements

; ───────────────────────────────────────────────────────────────────────────────
; Premium Summary
; ───────────────────────────────────────────────────────────────────────────────
{.premium}
dwelling = #$:(0..)                               ; Premium for dwelling coverage
buildings = #$:(0..)                              ; Premium for buildings coverage
personal_property = #$:(0..)                      ; Premium for personal property coverage
equipment = #$:(0..)                              ; Premium for equipment coverage
livestock = #$:(0..)                              ; Premium for livestock coverage
liability = #$:(0..)                              ; Premium for liability coverage
crops = #$:(0..)                                  ; Premium for crop coverage
endorsements = #$:(0..)                           ; Premium for endorsements
total_estimated = #$:(0..)                        ; Total estimated premium
minimum = #$:(0..)                                ; Minimum earned premium
deposit = #$:(0..)                                ; Deposit premium amount

{@farm_policy}

; ───────────────────────────────────────────────────────────────────────────────
; Loss History
; ───────────────────────────────────────────────────────────────────────────────
{@farm_policy.loss_history[]}
loss_date = date                                  ; Date of loss
type_of_loss = (
    building_fire,
    crop_hail,
    crop_other,
    dwelling_fire,
    equipment_damage,
    equipment_theft,
    liability_claim,
    livestock_death,
    livestock_theft,
    weather,
    wind
)                                                 ; Type of loss
property_paid = #$:(0..)                          ; Property claim amount paid
liability_paid = #$:(0..)                         ; Liability claim amount paid
total_paid = #$:(0..)                             ; Total claim amount paid
status = (closed, open, subrogation)              ; Claim status
description = :                                   ; Loss description

{@farm_policy}


; ===================================================================================
; ODIN Agriculture Livestock Schema
; ===================================================================================
; Livestock and animal records including identification, inventory, health records
; (vaccination, treatment), production, movement, and marketing.
; ===================================================================================

@import "../common/types.schema.odin" as types

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.agriculture.livestock"
version = "1.0.0"
title = "Agriculture Livestock Schema"
description = "Livestock records with identification, health, production, and movement"

{$derivation}
source[0].authority = "U.S. Department of Agriculture APHIS"
source[0].citation = "Animal Disease Traceability Requirements (9 CFR Part 86)"
source[0].url = "https://www.ecfr.gov/current/title-9/chapter-I/subchapter-C/part-86"

source[1].authority = "U.S. Department of Agriculture APHIS"
source[1].citation = "National Animal Identification System (NAIS) Guidelines"
source[1].url = "https://www.aphis.usda.gov/aphis/ourfocus/animalhealth/traceability"

source[2].authority = "U.S. Food and Drug Administration"
source[2].citation = "21 CFR Part 530 - Extralabel Drug Use in Animals"
source[2].url = "https://www.ecfr.gov/current/title-21/chapter-I/subchapter-E/part-530"

source[3].authority = "U.S. Department of Agriculture FSIS"
source[3].citation = "Livestock Slaughter Inspection Requirements"
source[3].url = "https://www.fsis.usda.gov/inspection"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial agriculture livestock schema"
changelog[0].rationale = "Livestock structures derived from APHIS traceability and FDA requirements"

; ===================================================================================
; ANIMAL
; ===================================================================================

{@animal}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
animal_id = !:                                   ; Unique animal identifier
official_id = :                                  ; Official USDA tag (NUES, 840, Brite)
farm_tag = :                                     ; Farm-specific tag/tattoo
name = :                                         ; Animal name (if applicable)
alternative_ids[] = @types.identifier            ; Alternative identifiers

; ───────────────────────────────────────────────────────────────────────────────
; Species & Breed
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
species = (bison, cattle, goat, horse, llama_alpaca, other, poultry, sheep, swine)
breed = :                                        ; Primary breed
breed_code = :                                   ; Breed association code
crossbred = ?                                    ; Crossbred animal
secondary_breed = :                              ; Secondary breed if crossbred
purebred = ?                                     ; Purebred registered
registry_number = :                              ; Breed registry number
registry_association = :                         ; Breed association name

{@animal}

; ───────────────────────────────────────────────────────────────────────────────
; Physical Characteristics
; ───────────────────────────────────────────────────────────────────────────────
{.physical}
sex = (bull, cow, ewe, female, gilt, heifer, male, ram, sow, steer, wether)
color = :                                        ; Color/markings
birth_date = date                                ; Date of birth
birth_weight_lbs = #:(0..)                       ; Birth weight (pounds)
current_weight_lbs = #:(0..)                     ; Current weight
weaning_weight_lbs = #:(0..)                     ; Weaning weight
mature_weight_lbs = #:(0..)                      ; Expected mature weight
horn_status = (dehorned, horned, naturally_polled, scurred)

{@animal}

; ───────────────────────────────────────────────────────────────────────────────
; Origin & Ownership
; ───────────────────────────────────────────────────────────────────────────────
{.origin}
birth_farm_ref = :                               ; Farm where born
premises_id = :                                  ; Premises ID (PIN)
birth_state = :(2)                               ; Birth state
birth_country = :(2..3)                          ; Birth country
dam_id = :                                       ; Mother ID
sire_id = :                                      ; Father ID
acquisition_date = date                          ; Date acquired
acquisition_source = :                           ; Source of acquisition
acquisition_price = #$:(0..)                     ; Purchase price
owner_id = :                                     ; Current owner ID
co_owner_id = :                                  ; Co-owner ID if applicable

{@animal}

; ───────────────────────────────────────────────────────────────────────────────
; Location & Status
; ───────────────────────────────────────────────────────────────────────────────
{.location}
current_farm_ref = !:                            ; Current farm reference
pen_lot = :                                      ; Pen or lot number
pasture = :                                      ; Pasture identifier
building = :                                     ; Building number/name
location_date = date                             ; Date placed at location

{@animal}

{.status}
status = (active, deceased, processed, sold, transferred)
status_date = date                               ; Status change date
death_date = date:if status = deceased           ; Date of death
death_reason = :if status = deceased             ; Reason for death
processed_date = date:if status = processed      ; Slaughter/processing date
disposition = :                                  ; Final disposition

{@animal}

; ───────────────────────────────────────────────────────────────────────────────
; Production Purpose
; ───────────────────────────────────────────────────────────────────────────────
{.purpose}
production_type = (breeding, dairy, dual_purpose, exhibition, feeder, finishing, replacement, show)
market_class = :                                 ; Market classification
carcass_value = #$:(0..)                         ; Expected carcass value

{@animal}

; ───────────────────────────────────────────────────────────────────────────────
; Health & Treatment
; ───────────────────────────────────────────────────────────────────────────────
health_events[] = @health_event

; ───────────────────────────────────────────────────────────────────────────────
; Production Records
; ───────────────────────────────────────────────────────────────────────────────
production_records[] = @production_record

; ───────────────────────────────────────────────────────────────────────────────
; Movement History
; ───────────────────────────────────────────────────────────────────────────────
movements[] = @movement

; ===================================================================================
; HERD (GROUP)
; ===================================================================================

{@herd}
= @types.audit_info

; ───────────────────────────────────────────────────────────────────────────────
; Identification
; ───────────────────────────────────────────────────────────────────────────────
herd_id = !:                                     ; Herd/group identifier
herd_name = :                                    ; Herd name
farm_ref = !:                                    ; Farm reference

; ───────────────────────────────────────────────────────────────────────────────
; Classification
; ───────────────────────────────────────────────────────────────────────────────
{.classification}
species = (bison, cattle, goat, poultry, sheep, swine)
herd_type = (beef, breeding, dairy, feeder, finishing, replacement)
production_system = (cage_free, conventional, free_range, organic, pasture_based)

{@herd}

; ───────────────────────────────────────────────────────────────────────────────
; Inventory
; ───────────────────────────────────────────────────────────────────────────────
{.inventory}
head_count = !##:(0..)                           ; Number of animals
average_weight_lbs = #:(0..)                     ; Average weight
total_weight_lbs = #:(0..)                       ; Total group weight
inventory_date = date                            ; Inventory count date

{@herd}

; ───────────────────────────────────────────────────────────────────────────────
; Location
; ───────────────────────────────────────────────────────────────────────────────
{.location}
premises_id = :                                  ; Premises ID
pen_lot = :                                      ; Pen or lot
pasture = :                                      ; Pasture
building = :                                     ; Building

{@herd}

; ───────────────────────────────────────────────────────────────────────────────
; Animals
; ───────────────────────────────────────────────────────────────────────────────
animals[] = @animal                              ; Individual animals in herd

; ===================================================================================
; HEALTH EVENT
; ===================================================================================

{@health_event}
; ───────────────────────────────────────────────────────────────────────────────
; Event Details
; ───────────────────────────────────────────────────────────────────────────────
event_id = !:                                    ; Health event ID
event_date = !date                               ; Date of event
event_type = (diagnosis, examination, surgery, test, treatment, vaccination)
animal_id = !:                                   ; Animal ID
herd_id = :                                      ; Herd ID if group treatment

; ───────────────────────────────────────────────────────────────────────────────
; Diagnosis/Condition
; ───────────────────────────────────────────────────────────────────────────────
{.diagnosis}
condition = :                                    ; Condition/disease name
symptoms = :                                     ; Observed symptoms
severity = (critical, mild, moderate, severe)
diagnosis_date = date                            ; Diagnosis date
outcome = (died, euthanized, recovered, recovering, unresolved)

{@health_event}

; ───────────────────────────────────────────────────────────────────────────────
; Treatment/Vaccination
; ───────────────────────────────────────────────────────────────────────────────
{.treatment}
product_name = :                                 ; Drug/vaccine name
manufacturer = :                                 ; Manufacturer
lot_number = :                                   ; Product lot number
dosage = #:(0..)                                 ; Dosage amount
dosage_unit = (cc, grams, ml, units)
route = (im, intranasal, iv, oral, sc, topical)  ; Administration route (intramuscular, etc.)
withdrawal_days_meat = ##:(0..)                  ; Meat withdrawal period
withdrawal_days_milk = ##:(0..)                  ; Milk withdrawal period
slaughter_date_restriction = date                ; Cannot process before this date
treatment_duration_days = ##:(0..)               ; Treatment duration

{@health_event}

; ───────────────────────────────────────────────────────────────────────────────
; Veterinarian
; ───────────────────────────────────────────────────────────────────────────────
{.veterinarian}
vet_name = :                                     ; Veterinarian name
vet_license = :                                  ; License number
vet_practice = :                                 ; Practice name
prescription_number = :                          ; Prescription number if applicable
extra_label_use = ?                              ; Extra-label drug use (FDA)

{@health_event}

; ───────────────────────────────────────────────────────────────────────────────
; Costs
; ───────────────────────────────────────────────────────────────────────────────
{.costs}
product_cost = #$:(0..)                          ; Product cost
service_cost = #$:(0..)                          ; Service/vet cost
total_cost = #$:(0..)                            ; Total cost

; ===================================================================================
; PRODUCTION RECORD
; ===================================================================================

{@production_record}
; ───────────────────────────────────────────────────────────────────────────────
; Record Details
; ───────────────────────────────────────────────────────────────────────────────
record_id = !:                                   ; Production record ID
record_date = !date                              ; Date recorded
animal_id = :                                    ; Individual animal ID
herd_id = :                                      ; Herd ID if group record
production_type = (breeding, calving_kidding_lambing, dairy, egg, fiber, weight)

; ───────────────────────────────────────────────────────────────────────────────
; Dairy Production
; ───────────────────────────────────────────────────────────────────────────────
{.dairy}
milk_weight_lbs = #:(0..):if production_type = dairy
butterfat_percent = #:(0..100):if production_type = dairy
protein_percent = #:(0..100):if production_type = dairy
scc = ##:(0..):if production_type = dairy        ; Somatic cell count
test_date = date:if production_type = dairy
lactation_number = ##:(1..):if production_type = dairy
days_in_milk = ##:(0..):if production_type = dairy

{@production_record}

; ───────────────────────────────────────────────────────────────────────────────
; Reproduction/Breeding
; ───────────────────────────────────────────────────────────────────────────────
{.breeding}
breeding_date = date:if production_type = breeding
breeding_method = (ai, embryo_transfer, natural):if production_type = breeding
sire_id = :if production_type = breeding
service_number = ##:(1..):if production_type = breeding
expected_due_date = date:if production_type = breeding
pregnancy_confirmed = ?:if production_type = breeding
confirmation_date = date:if production_type = breeding

{@production_record}

; ───────────────────────────────────────────────────────────────────────────────
; Birth/Calving/Kidding/Lambing
; ───────────────────────────────────────────────────────────────────────────────
{.birth}
birth_date = date:if production_type = calving_kidding_lambing
calving_ease = (assisted, caesarean, difficult, normal):if production_type = calving_kidding_lambing
offspring_count = !##:(1..):if production_type = calving_kidding_lambing
live_births = ##:(0..):if production_type = calving_kidding_lambing
stillborn = ##:(0..):if production_type = calving_kidding_lambing
birth_weight_lbs = #:(0..):if production_type = calving_kidding_lambing
offspring_ids[] = :if production_type = calving_kidding_lambing

{@production_record}

; ───────────────────────────────────────────────────────────────────────────────
; Weight Records
; ───────────────────────────────────────────────────────────────────────────────
{.weight}
weight_lbs = #:(0..):if production_type = weight
weight_type = (birth, current, sale, weaning, yearling):if production_type = weight
adjusted_weight = #:(0..):if production_type = weight
weight_gain_lbs = #:if production_type = weight
adg = #:(0..):if production_type = weight        ; Average daily gain

{@production_record}

; ───────────────────────────────────────────────────────────────────────────────
; Egg Production
; ───────────────────────────────────────────────────────────────────────────────
{.egg}
egg_count = ##:(0..):if production_type = egg
dozen_count = #:(0..):if production_type = egg
grade_a_count = ##:(0..):if production_type = egg
grade_b_count = ##:(0..):if production_type = egg
flock_age_weeks = ##:(0..):if production_type = egg

{@production_record}

; ───────────────────────────────────────────────────────────────────────────────
; Fiber Production
; ───────────────────────────────────────────────────────────────────────────────
{.fiber}
fiber_weight_lbs = #:(0..):if production_type = fiber
fiber_type = (cashmere, mohair, wool):if production_type = fiber
fiber_grade = :if production_type = fiber
shearing_date = date:if production_type = fiber

; ===================================================================================
; MOVEMENT
; ===================================================================================

{@movement}
; ───────────────────────────────────────────────────────────────────────────────
; Movement Details
; ───────────────────────────────────────────────────────────────────────────────
movement_id = !:                                 ; Movement ID
movement_date = !date                            ; Date of movement
movement_type = (death, purchase, received, sale, shipped, transfer)

; ───────────────────────────────────────────────────────────────────────────────
; Animals Moved
; ───────────────────────────────────────────────────────────────────────────────
{.animals}
individual_ids[] = :                             ; Individual animal IDs
herd_id = :                                      ; Herd ID if group movement
head_count = ##:(0..)                            ; Number of animals
species = :                                      ; Species moved
total_weight_lbs = #:(0..)                       ; Total weight

{@movement}

; ───────────────────────────────────────────────────────────────────────────────
; Origin (APHIS Required for Interstate)
; ───────────────────────────────────────────────────────────────────────────────
{.origin}
origin_name = :                                  ; Origin farm/facility name
origin_premises_id = :                           ; Origin premises ID
origin_address = @types.address                  ; Origin address
origin_state = :(2)                              ; Origin state
origin_country = :(2..3) "US"                    ; Origin country

{@movement}

; ───────────────────────────────────────────────────────────────────────────────
; Destination (APHIS Required for Interstate)
; ───────────────────────────────────────────────────────────────────────────────
{.destination}
destination_name = :                             ; Destination name
destination_premises_id = :                      ; Destination premises ID
destination_address = @types.address             ; Destination address
destination_state = :(2)                         ; Destination state
destination_country = :(2..3) "US"               ; Destination country
destination_type = (auction, dealer, farm, feedlot, pasture, processor, show, slaughter)

{@movement}

; ───────────────────────────────────────────────────────────────────────────────
; Interstate Certificate of Veterinary Inspection (CVI)
; ───────────────────────────────────────────────────────────────────────────────
{.cvi}
cvi_number = :                                   ; CVI/health certificate number
cvi_issue_date = date                            ; CVI issue date
cvi_expiration = date                            ; CVI expiration
issuing_vet = :                                  ; Issuing veterinarian
vet_license = :                                  ; Vet license number
issuing_state = :(2)                             ; State issuing CVI
purpose = :                                      ; Purpose of movement

{@movement}

; ───────────────────────────────────────────────────────────────────────────────
; Transportation
; ───────────────────────────────────────────────────────────────────────────────
{.transport}
carrier_name = :                                 ; Carrier/hauler name
driver_name = :                                  ; Driver name
vehicle_id = :                                   ; Vehicle/trailer ID
departure_date = date                            ; Departure date
arrival_date = date                              ; Arrival date
transport_duration_hours = #:(0..)               ; Transport duration

{@movement}

; ───────────────────────────────────────────────────────────────────────────────
; Financial
; ───────────────────────────────────────────────────────────────────────────────
{.financial}
price_per_head = #$                              ; Price per head
price_per_cwt = #$                               ; Price per hundredweight
total_price = #$:(0..)                           ; Total transaction price
transport_cost = #$:(0..)                        ; Transportation cost
commission = #$:(0..)                            ; Commission/fees

; ===================================================================================
; FEEDING RECORD
; ===================================================================================

{@feeding_record}
; ───────────────────────────────────────────────────────────────────────────────
; Record Details
; ───────────────────────────────────────────────────────────────────────────────
record_id = !:                                   ; Feeding record ID
record_date = !date                              ; Date recorded
herd_id = :                                      ; Herd ID
pen_lot = :                                      ; Pen/lot identifier

; ───────────────────────────────────────────────────────────────────────────────
; Feed Details
; ───────────────────────────────────────────────────────────────────────────────
{.feed}
feed_type = (concentrate, forage, grain, hay, mineral, silage, supplement)
feed_name = !:                                   ; Feed name/description
quantity_lbs = !#:(0..)                          ; Quantity fed (pounds)
quantity_tons = #:(0..)                          ; Quantity fed (tons)
dry_matter_percent = #:(0..100)                  ; Dry matter percentage
protein_percent = #:(0..100)                     ; Crude protein percentage
tdn_percent = #:(0..100)                         ; Total digestible nutrients
cost_per_ton = #$:(0..)                          ; Cost per ton
total_cost = #$:(0..)                            ; Total feed cost

{@feeding_record}

; ───────────────────────────────────────────────────────────────────────────────
; Consumption
; ───────────────────────────────────────────────────────────────────────────────
{.consumption}
head_count = ##:(1..)                            ; Number of animals
lbs_per_head = #:(0..)                           ; Feed per head
consumption_method = (bunk, free_choice, trough)

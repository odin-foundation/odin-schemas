; ===================================================================================
; ODIN Retail Product Schema
; ===================================================================================
; Product catalog, SKU management, variants, and merchandise hierarchy.
; ===================================================================================

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.retail.product"
version = "1.0.0"
title = "Retail Product Schema"
description = "Product catalog, SKU management, variants, and merchandise hierarchy"

{$derivation}
source[0].authority = "GS1"
source[0].citation = "GS1 General Specifications - Product Identification"
source[0].url = "https://www.gs1.org/standards"

source[1].authority = "NRF"
source[1].citation = "National Retail Federation Standards"
source[1].url = "https://nrf.com/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

changelog[0].date = 2025-12-21
changelog[0].change = "Initial retail product schema"
changelog[0].rationale = "Product structures derived from GS1 and NRF standards"

; ===================================================================================
; MERCHANDISE HIERARCHY
; ===================================================================================

{@merchandise_hierarchy}
department_code = :                             ; Department code
department_name = :                             ; Department name
class_code = :                                   ; Class code
class_name = :                                   ; Class name
subclass_code = :                                ; Subclass code
subclass_name = :                                ; Subclass name
category_code = :                                ; Category code
category_name = :                                ; Category name

; ===================================================================================
; PRODUCT
; ===================================================================================

{@product}
= @types.base_product

; Identifiers
{.identifiers}
ean = :                                          ; EAN-13 barcode
style_number = :                                 ; Style number
vendor_sku = :                                   ; Vendor SKU

{@product}

; Classification
merchandise = @merchandise_hierarchy             ; Merchandise hierarchy

; Description
long_description = :                             ; Full description
features[] = :                                   ; Feature bullets
keywords[] = :                                   ; Search keywords

; Manufacturer
{.manufacturer}
country_of_origin = :(2..3)                      ; ISO country code

{@product}

; Variants
variants[] = @product_variant                    ; Product variants/SKUs

; Flags
taxable = ?true                                  ; Taxable product
returnable = ?true                               ; Returnable flag
hazmat = ?                                       ; Hazardous material
age_restricted = ?                               ; Age verification required

; Lifecycle
introduction_date = date                         ; Product introduction date
discontinue_date = date                          ; Discontinuation date

; ===================================================================================
; PRODUCT VARIANT
; ===================================================================================

{@product_variant}
variant_id = :                                  ; Variant identifier
parent_product_id = :                           ; Parent product ID

; Variant attributes
color = :                                        ; Color
color_code = :                                   ; Color code
size = :                                         ; Size
size_order = ##                                  ; Size sort order
style = :                                        ; Style variation

; Identifiers
gtin = :                                         ; Variant GTIN
upc = :                                          ; Variant UPC
sku = :                                         ; Variant SKU

active = ?true                                   ; Variant active status
discontinued = ?                                 ; Discontinued flag

; Images
{.images}
primary_image_url = :                            ; Primary product image
thumbnail_url = :                                ; Thumbnail image
swatch_url = :                                   ; Color swatch image
additional_images[] = :                          ; Additional images

{@product_variant}

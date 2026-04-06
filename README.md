# ODIN Schema Library

**337 schemas. 2,666 types. 55,189 fields. 18 industries.**

The ODIN Schema Library is the largest open collection of industry-specific data schemas written in a single, self-describing notation. Every schema is a valid ODIN document that describes ODIN structure — the same parser, the same syntax, the same tooling.

> **Community Working Draft (CWD)** — These schemas are published as a Community Working Draft, inviting industry participants to evaluate, implement, and contribute feedback prior to final standardization. CWD status means the schemas are structurally complete and usable in production, but field names, types, and constraints may evolve based on community input before reaching Recommendation status.

## What is a CWD?

A **Community Working Draft** is the first formal publication stage in the ODIN standardization process. It signals that:

- **The schema is structurally complete** — all types, fields, and relationships are defined
- **The schema is derived from authoritative sources** — every schema includes a `{$derivation}` section citing the regulatory bodies, industry standards, or institutional references it draws from
- **The schema is ready for implementation** — organizations can build against CWD schemas today, with the understanding that non-breaking refinements may occur
- **Community feedback is actively sought** — field naming, constraint values, enum lists, and structural decisions are open for review

### CWD Lifecycle

```
Working Draft (internal) → Community Working Draft (public) → Candidate Recommendation → Recommendation (stable)
```

CWD schemas advance to **Candidate Recommendation** when:
1. At least two independent implementations validate the schema
2. Community feedback has been incorporated
3. No open structural issues remain

Schemas at **Recommendation** status are frozen — changes require a new version.

## Sectors

| Sector | Schemas | Description |
|--------|---------|-------------|
| **Agriculture** | Crops, livestock, equipment, commodities, and traceability |
| **Automotive** | Vehicles, dealers, fleets, inspections, and transactions |
| **Common** | Shared types and definitions used across all sectors |
| **Construction** | Projects, bids, contracts, schedules, safety, and liens |
| **Education** | Students, academics, credentials, assessments, and financial aid |
| **Employment** | Payroll, benefits, recruitment, performance, and compliance |
| **Finance** | Securities, payments, derivatives, FX, lending, and treasury |
| **Government** | Taxation, licensing, permitting, procurement, and benefits |
| **Healthcare** | Clinical records, claims, pharmacy, Medicare, and Medicaid |
| **Insurance** | Personal, commercial, specialty, life, and reinsurance |
| **Legal** | Contracts, litigation, compliance, corporate, and IP |
| **Logistics** | Shipping, warehousing, customs, fleet, and supply chain |
| **Manufacturing** | Production, quality, inventory, and supply chain |
| **Mortgage** | Loan origination, servicing, closing, and compliance |
| **Real Estate** | Listings, transactions, appraisals, and property management |
| **Retail** | Products, orders, inventory, customers, and POS |
| **Telecom** | Network, subscribers, billing, provisioning, and services |
| **Utilities** | Metering, billing, generation, distribution, and grid |

## Schema Structure

Every schema follows a consistent structure:

```odin
; Header comment block with description

{$}
odin = "1.0.0"
schema = "1.0.0"
id = "foundation.odin.schema.insurance.certificate"
version = "1.0.0"
title = "Insurance Certificate Schema"
description = "Evidence of insurance coverage for commercial and personal lines"

{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "Evidence of Insurance Requirements"
source[0].url = "https://www.tdi.texas.gov/"
methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false

{@certificate_coverage_line}
policy_number = !:               ; Required string field
effective = !date                ; Required date field
expiration = !date               ; Required date field
sequence = ##:(1..)              ; Optional integer, minimum 1
```

### Field Syntax

Fields use ODIN's self-describing type system with inline constraints:

| Symbol | Meaning | Example |
|--------|---------|---------|
| `!` | Required | `name = !:` |
| `*` | Confidential | `ssn = *:` |
| `-` | Deprecated | `old_field = -:` |
| `:` | String | `name = :` |
| `#` | Number | `rate = #:(0..1)` |
| `##` | Integer | `count = ##:(0..)` |
| `#$` | Currency | `amount = #$` |
| `?` | Boolean | `active = ?` |
| `@` | Reference | `policy = @policy_type` |
| `date` | Date | `effective = date` |
| `timestamp` | Timestamp | `created = timestamp` |
| `^` | Binary | `signature = ^` |

### Constraints

Constraints are written inline after the type symbol:

```odin
age = ##:(18..120)                         ; Integer between 18 and 120
email = :/^[^@]+@[^@]+\.[^@]+$/           ; Regex pattern match
status = ("active", "inactive", "pending") ; Enum of allowed values
rate = #:(0..1)                            ; Number between 0 and 1
```

### Imports

Schemas compose via imports — shared types are defined once in `common/` and referenced across sectors:

```odin
@import common/types as types
@import common/address as address

{@customer}
name = @types.person_name       ; Reuses the person_name type
address = @address.postal       ; Reuses the postal address type
```

## Derivation & Provenance

Every schema includes a `{$derivation}` section documenting where it came from. This is not optional — it's a core principle of the ODIN schema library.

```odin
{$derivation}
source[0].authority = "Texas Department of Insurance"
source[0].citation = "Evidence of Insurance Requirements"
source[0].url = "https://www.tdi.texas.gov/"

source[1].authority = "California Department of Insurance"
source[1].citation = "Certificate of Insurance Guidelines"
source[1].url = "https://www.insurance.ca.gov/"

methodology = "regulatory_derivation"
proprietary_sources_consulted = ?false
notes = "Derived from public regulatory requirements and open industry standards"
```

### Authoritative Sources by Sector

| Sector | Primary Sources |
|--------|----------------|
| Insurance | NAIC, State DOI regulations |
| Healthcare | HL7 FHIR, CMS, HIPAA |
| Finance | FpML, ISO 20022, SEC regulations |
| Legal | ALTA, ABA, court filing standards |
| Mortgage | MISMO, CFPB, Fannie Mae/Freddie Mac |
| Government | OMB, IRS, OPM, federal form standards |
| Automotive | NHTSA, EPA, state DMV requirements |

**No schema is derived from proprietary or copyrighted data models.** All schemas are built from publicly available regulatory requirements, open standards, and industry best practices. The `proprietary_sources_consulted = ?false` field in each derivation section makes this explicit.

## Directory Structure

```
schemas/
  agriculture/           # Crops, livestock, equipment
  automotive/            # Vehicles, dealers, fleets
  common/                # Shared types (address, person_name, etc.)
  construction/          # Projects, bids, contracts
  education/             # Students, credentials, financial aid
  employment/            # Payroll, benefits, recruitment
  finance/               # Securities, payments, derivatives
  government/            # Tax, licensing, procurement
  healthcare/            # Clinical, claims, pharmacy
  insurance/             # Personal, commercial, specialty, life
    personal/            #   Auto, home, umbrella
    commercial/          #   Property, liability, workers comp
    specialty/           #   Cyber, E&O, D&O
    life/                #   Term, whole, universal
    certificate.schema.odin
    ...
  legal/                 # Contracts, litigation, IP
  logistics/             # Shipping, customs, fleet
  manufacturing/         # Production, quality, inventory
  mortgage/              # Origination, servicing, closing
  realestate/            # Listings, transactions, appraisals
  retail/                # Products, orders, POS
  telecom/               # Network, billing, provisioning
  utilities/             # Metering, billing, generation
```

## Usage

### Browse Online

The full schema library is browsable at [odin.foundation/schemas](https://odin.foundation/schemas) with search, type expansion, and field-level documentation.

### Programmatic Access

```
# Schema as JSON (for tooling)
https://odin.foundation/schemas/{sector}/{name}.json

# Schema source (ODIN format)
https://odin.foundation/schemas/{sector}/{name}.schema.odin

# Search index
https://odin.foundation/schemas/search-index.json
```

### SDK Integration

```typescript
import { Odin } from '@odin-foundation/core';

// Parse a schema
const schema = Odin.parse(schemaText);

// Validate data against a schema
const doc = Odin.parse(dataText);
// Schema validation ensures data conforms to type definitions and constraints
```

## Contributing

Schemas are derived from public, authoritative sources. To propose changes:

1. **Open an issue** describing the change and citing the authoritative source
2. **Reference the standard** — changes must trace to a regulatory body, open standard, or industry consensus
3. **Maintain provenance** — update the `{$derivation}` section with new sources and changelog entries

All schemas in this repository are published under the [ODIN Foundation License](../LICENSE).

## Learn More

- [ODIN Schema Language Reference](https://odin.foundation/reference/schema) — Full schema syntax documentation
- [ODIN 1.0 Specification](https://odin.foundation/reference/spec) — Core ODIN notation
- [Schema Library Browser](https://odin.foundation/schemas) — Search and explore all 337 schemas

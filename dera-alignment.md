# DERA–SCHEMA-AP-NDE Comparative Analysis

## 1. Introduction

The [Schema.org Application Profile for NDE](https://docs.nde.nl/schema-profile/) (SCHEMA-AP-NDE) is the generic data model for publishing linked data in the Dutch heritage network. Its scope section states that it applies to the network 'which implements the National Digital Heritage Strategy and Digital Reference Heritage Architecture' ([`index.bs.liquid` §1](index.bs.liquid)).

The [Digital Heritage Reference Architecture](https://dera.netwerkdigitaalerfgoed.nl) (DERA) defines the business objects, actors, roles, principles and services that structure the heritage network. The AP should be understood as one concrete realisation of that architecture.

This document systematically compares DERA and the AP, identifies terminological, conceptual and architectural gaps, and proposes concrete recommendations for better alignment.

### Sources

- DERA wiki: <https://dera.netwerkdigitaalerfgoed.nl> (business objects, principles, actors, roles, services, glossary)
- AP specification: [`index.bs.liquid`](index.bs.liquid) (definitions §2, scope §1, data model §4)
- SHACL shapes: [`shacl.ttl`](shacl.ttl) (class descriptions, property constraints)
- GitHub issue [#102](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/102): standalone Person/Organization/Place records cannot reference their Dataset

---

## 2. Terminological Comparison

The table below maps every DERA business object to its closest AP equivalent. Alignment is rated as: **strong** (clear correspondence), **partial** (some overlap but notable differences), **divergence** (same term, different meaning) or **gap** (no AP equivalent).

| DERA Business Object | DERA Definition (Dutch) | AP Equivalent | Alignment |
|---|---|---|---|
| **Cultuurhistorisch object** | 'Een object met een bepaalde cultuurhistorische waarde' | Heritage object / CreativeWork | **Partial** — see [§3.1](#31-heritage-object--metadata-record-circularity) |
| **Informatieobject** | 'Een op zichzelf staand geheel van gegevens met een eigen identiteit' | MediaObject | **Partial** — DERA's scope is broader (letters, web pages, subsidy applications); the AP treats MediaObject as a supporting class for digital reproductions only |
| **Gedigitaliseerd erfgoed** | Material digitised from a non-digital original | MediaObject (implicit) | **Partial** — the AP does not distinguish digitised from born-digital |
| **Digital born erfgoed** | Material that was originally digital | MediaObject (implicit) | **Partial** — same as above |
| **Metadata (cultuurhistorisch object)** | Metadata describing a cultural heritage object | Metadata record typed as CreativeWork | **Strong** |
| **Metadata (informatieobject)** | Metadata describing an information object | No clear equivalent | **Gap** — MediaObject metadata is not independently addressable |
| **Metadata (persoon/organisatie/plaats)** | *(Not defined in DERA)* | Metadata record typed as Person / Organization / Place | **Gap** — see [§3.2](#32-personorganization-actors-vs-described-entities) |
| **Dataset** | 'Een verzameling van metadata, al dan niet aangevuld met informatieobjecten' | Dataset (referenced via `isPartOf` on CreativeWork) | **Partial** — aligned in concept, but only CreativeWork can reference a dataset; see [§3.5](#35-dataset-membership-gap) |
| **Term** | 'Een aanduiding van een entiteit of onderwerp' | Term / DefinedTerm | **Strong** |
| **Terminologiebron** | 'Een verzameling gepubliceerde termen die onder regie van een bronhouder worden beheerd' | Network of Terms (Termennetwerk) | **Strong** |
| **Verrijking** | 'Een verrijking maakt informatie die voorkomt in het oorspronkelijke erfgoedobject of anderszins hoort tot de context expliciet(er)' | No equivalent | **Gap** — see [§3.4](#34-enrichments-not-addressed) |
| **Actor** | 'Een persoon of organisatorische entiteit die gedrag kan uitvoeren' | Person / Organization | **Divergence** — see [§3.2](#32-personorganization-actors-vs-described-entities) |
| **Erfgoedinformatie** | 'De totale informatieruimte die betrekking heeft op cultuurhistorische objecten' | No equivalent | **Gap** — the AP does not name the total information space |
| **Bronhouder** | 'Eigenaar en verantwoordelijk voor het beheer van minimaal één bron met erfgoedinformatie' | Publisher (in NDE-DATASETS, not in the AP itself) | **Partial** — covered in the dataset description spec, not in the AP |
| **Alignment** | 'Relatie tussen erfgoedinformatie uitdrukkende gelijk(waardig)heid' | `sameAs` on DefinedTerm | **Partial** — only for term-to-term relations |

---

## 3. Conceptual Analysis

### 3.1 Heritage object / metadata record circularity

The AP defines two mutually dependent terms:

> **Metadata record**: An RDF resource that expresses one of the top-level classes in the §4 Data model. Description of a heritage object. (`index.bs.liquid` §2)
>
> **Heritage object**: Physical or digital object that is described by a metadata record. (`index.bs.liquid` §2)

The first sentence of 'metadata record' correctly includes all four top-level classes (CreativeWork, Person, Organization, Place). The second sentence then restricts it to heritage objects. But the CreativeWork SHACL description explicitly states that CreativeWork is 'the catch-all type for all heritage objects in this application profile, to differentiate them from the other top-level classes (Person, Organization, Place)' (`shacl.ttl`). These two sentences therefore contradict each other.

In DERA, a 'cultuurhistorisch object' is 'een object met een bepaalde cultuurhistorische waarde.' This is broader than the AP's 'heritage object', which is limited to things described by a metadata record. The DERA definition encompasses material, immaterial, conceptual and digital objects — it does not depend on a metadata description for its identity.

**Issues:**
- The AP definition is circular: a heritage object is defined by its metadata record, and a metadata record is defined as describing a heritage object.
- Person, Organization and Place records are metadata records by the first sentence but not by the second.
- The AP's 'heritage object' is narrower than DERA's 'cultuurhistorisch object.'

### 3.2 Person/Organization: actors vs. described entities

This is the most significant conceptual divergence between DERA and the AP.

In DERA, persons and organisations appear exclusively as **actors** — participants in the heritage network who perform roles. The DERA glossary defines an actor as 'een persoon of organisatorische entiteit die gedrag kan uitvoeren' (a person or organisational entity capable of performing behaviour). DERA identifies four actor types: heritage institutions (*erfgoedinstellingen*), collaborative partnerships (*samenwerkingsverbanden*), suppliers (*leveranciers*) and users (*gebruikers*). These actors fulfil roles such as data holder (*bronhouder*), broker (*makelaar*) or consumer (*afnemer*).

Crucially, **DERA has no business object for 'a person as the subject of a metadata description.'** The five DERA metadata subtypes are:

1. Metadata cultuurhistorisch object
2. Metadata informatieobject
3. Metadata dataset
4. Metadata terminologiebron
5. Metadata verrijkingen

There is no 'Metadata persoon', 'Metadata organisatie' or 'Metadata plaats'. Standalone person records that describe biographical data (e.g. an artist's birth date, occupation and places of activity) have no place in DERA's business object model.

In the AP, Person and Organization are **described entities** — first-class top-level classes for metadata records, alongside CreativeWork and Place. The AP's Person shape defines properties like `birthDate`, `deathDate`, `birthPlace`, `deathPlace` and `hasOccupation` — all describing a person, not a network participant.

**This makes the issue raised in [#102](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/102) more fundamental than a Schema.org technical limitation.** The absence of `isPartOf` on Person/Organization/Place reflects not merely Schema.org's domain constraint on that property, but a deeper conceptual gap: DERA's entire architecture is built around describing cultural-historical objects and their information objects. The AP extends beyond DERA's conceptual scope by treating persons, organisations and places as first-class described entities.

### 3.3 MediaObject: supporting class vs. independent entity

In DERA, an informatieobject is a first-class business object defined as 'een op zichzelf staand geheel van gegevens met een eigen identiteit.' This includes diverse information carriers: letters, web pages, photographs, films and subsidies. DERA explicitly recognises digitised heritage (*gedigitaliseerd erfgoed*) and born-digital heritage (*digital born erfgoed*) as distinct categories.

In the AP, MediaObject is documented as 'a supporting class, used through the `associatedMedia` property on CreativeWork' (`index.bs.liquid` §4). It has no `sh:targetClass` declaration in the SHACL shapes and cannot exist independently of a CreativeWork. The AP's MediaObject is also narrower than DERA's informatieobject: it covers only digital media (images, video, audio, 3D models), not the full range of information objects DERA envisions.

The relationship between DERA and AP concepts can be mapped as:

| DERA Concept | AP Concept | Relationship |
|---|---|---|
| Cultuurhistorisch object | The physical/digital heritage object itself | Not directly expressed in RDF |
| Informatieobject | MediaObject | Narrower: digital media only |
| Metadata cultuurhistorisch object | CreativeWork record | The RDF description |
| Metadata informatieobject | MediaObject properties | Embedded, not independent |

DERA also states that 'metagegevens zijn zelf ook informatieobjecten' (metadata are themselves information objects) — a recursive relationship the AP does not reflect.

### 3.4 Enrichments not addressed

DERA defines a verrijking (enrichment) as making 'informatie die voorkomt in het oorspronkelijke erfgoedobject of anderszins hoort tot de context expliciet(er).' The [enrichment architecture pattern](https://dera.netwerkdigitaalerfgoed.nl/index.php/Verrijkingen) describes a four-layer model (business, application, information, technology) with its own lifecycle, management system and services.

Enrichment forms include:
- Transcriptions and translations
- OCR output
- Named Entity Recognition results
- Error corrections
- Contextual supplementation (who, what, where, when, why, how)
- Alignments with terminology sources

DERA defines dedicated services for enrichments: 'Published enrichment metadata' and 'Published enrichments.' There is a dedicated role, 'Bronhouder metadata verrijkingen' (enrichment metadata holder).

The AP has no concept, class, property or guidance for enrichments. There is no mechanism to express that a piece of information is an enrichment of an existing metadata record, who created it, or how it relates to the original. Properties like `about` or `additionalType` could in principle be used, but the AP offers no guidance on this.

### 3.5 Dataset membership gap

The AP defines `isPartOf` only on CreativeWork (`shacl.ttl`). This makes sense for heritage object descriptions that belong to a dataset, but creates a gap for standalone Person, Organization and Place records.

Schema.org constrains `isPartOf` to `CreativeWork` as its domain, so the AP cannot simply extend it to other classes without violating Schema.org conformance. However, the heritage network does contain standalone Person records (e.g. artist authority records) that circulate independently and need to indicate their dataset provenance.

This issue is tracked in [#102](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/102).

### 3.6 Place as described entity

Place is a top-level class in the AP but has no direct counterpart in DERA's business object model. DERA does not define 'metadata plaats' or treat locations as independent business objects. In the AP, Place records can describe locations with names, addresses and geo-coordinates — but, like Person and Organization, they cannot reference their dataset.

---

## 4. Architectural Alignment: DERA Principles

DERA defines eight principles (*principes*) that the heritage architecture must fulfil. The table below assesses how the AP implements each.

| # | DERA Principle | Summary | AP Implementation | Assessment |
|---|---|---|---|---|
| 1 | **Authenticiteit** — ensure heritage information's authenticity is clear | Users must be able to verify information is integral, trustworthy and authentic | `sdDatePublished` records when the metadata record was last changed | **Limited** — only captures a last-modified date; no provenance chain, no integrity verification, no creator attribution on the metadata itself |
| 2 | **Beschikbaarheid** — ensure availability is clear | Users must determine access conditions, authorisation, format and durability | `license` on MediaObject; publication methods (resolvable URIs + data dumps + optional SPARQL) | **Partial** — licensing and access formats are covered, but long-term preservation and authorisation are not addressed |
| 3 | **Herkenbaarheid en gebruiksvriendelijkheid** — present heritage recognisably and user-friendly | Standardised presentation enables users to compare content across providers | The generic data model itself, with its prescribed classes and properties | **Strong** — this is the AP's raison d'être |
| 4 | **Eenduidige beschrijving** — describe heritage information unambiguously | Heritage information must be described consistently, with clear type identification | SHACL shapes enforce required properties, class typing, language tags and value constraints | **Strong** |
| 5 | **Verwijzingen** — ensure heritage information references | Context must be established through references to related information and standardised definitions | DefinedTerm with `sameAs` for vocabulary terms; `isPartOf` for datasets; `about`, `contentLocation`, `creator` for related entities | **Strong** — but only for CreativeWork; Person/Organization/Place have limited referencing capability |
| 6 | **Verwijsbaarheid** — ensure heritage information is referenceable | Others must be able to create relationships to heritage information | Persistent URIs required for all top-level classes; blank nodes prohibited for CreativeWork and Organization | **Strong** |
| 7 | **Respecteer diversiteit** — respect diversity of heritage information | Generic provisions must be content-neutral; data holders retain autonomy | Generic model alongside domain models (CIDOC-CRM, Linked Art, RiC-O, RDA); combined and profile-based publication methods | **Strong** |
| 8 | **Gedistribueerde informatie** — ensure distributed heritage information | Information is aggregated from multiple source systems; no central store | Publication via resolvable URIs + data dumps; no central repository required | **Strong** |

**Summary:** The AP aligns strongly with DERA principles 3–8, which concern discoverability, consistency, referencing and distributed architecture. Alignment is weaker for principles 1 (authenticity) and 2 (availability), where the AP provides limited support for provenance, integrity verification and long-term preservation.

---

## 5. Recommendations

### a. Broaden the 'metadata record' definition

The current second sentence — 'Description of a heritage object' — contradicts the first sentence and excludes Person, Organization and Place records. Replace with a formulation that covers all top-level classes, such as: 'An RDF resource that describes an entity in the heritage network, typed as one of the top-level classes in §4.'

### b. Reconsider the 'heritage object' definition

The current definition is circular and narrower than DERA's 'cultuurhistorisch object.' Consider either:
- aligning with DERA's definition ('een object met een bepaalde cultuurhistorische waarde'), or
- restricting 'heritage object' explicitly to things typed as CreativeWork and removing it from the metadata record definition.

### c. Address the dataset membership gap for Person/Organization/Place

Investigate how standalone Person, Organization and Place records can indicate their dataset provenance, given Schema.org's domain constraint on `isPartOf`. Possible approaches include using a different property, a custom extension, or named graphs. This is tracked in [#102](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/102).

### d. Elevate MediaObject or clarify its status

Either promote MediaObject to a top-level class (with its own `sh:targetClass` and ability to exist independently of CreativeWork), or explicitly document that the AP intentionally narrows DERA's informatieobject concept to digital reproductions accessible through CreativeWork.

### e. Add DERA terminology cross-references in AP definitions

Add cross-references in the AP so readers can trace AP concepts back to DERA business objects. For example, the CreativeWork description could note its correspondence to 'Metadata cultuurhistorisch object' in DERA; the DefinedTerm description could reference DERA's 'Term.'

### f. Document how enrichments map (or don't) to the AP

DERA's enrichment architecture is well-developed, with dedicated services, roles and a four-layer model. The AP should at minimum acknowledge this gap and provide guidance on whether and how enrichments can be expressed using AP classes and properties. If enrichments are out of scope, state this explicitly.

### g. Clarify that Person/Organization in the AP ≠ Actor in DERA

DERA's 'actor' (person or organisation performing behaviour in the network) is fundamentally different from the AP's Person/Organization (entities described by metadata records). The AP should explicitly acknowledge this distinction to prevent confusion. The AP extends beyond DERA's conceptual model by treating persons and organisations as described entities, not merely as network participants.

### h. Add an explicit 'Relationship to DERA' section in the AP

The AP references DERA in its scope statement but does not elaborate on how it implements or departs from DERA. A dedicated section would:
- map AP classes to DERA business objects
- acknowledge intentional departures (e.g. Person/Organization as described entities)
- note gaps (enrichments, informatieobject breadth)
- help readers navigate between the two documents

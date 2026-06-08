# Contributing

Thanks for helping improve the Schema.org Application Profile for NDE (SCHEMA-AP-NDE).

This profile is a deliberately **minimal, curated subset** of [Schema.org](https://schema.org).
Its value to dataset publishers and to service-platform builders comes precisely from that restraint:
a small, shared model is easier to produce against and to consume across datasets than the full Schema.org surface.
So the default answer to “should we add this?” is a careful no – the bar for adding a class or property is high, and the sections below describe how we decide.

## Proposing a change

Open an issue describing the class or property you would like to add or change, with a concrete JSON-LD example and the real-world need behind it.
You do not need to gather all the evidence below yourself – the maintainers verify it – but pointing at datasets that already publish the data helps.

## How proposals are evaluated

A proposed class or property is assessed against the following criteria. None is a sole gate; together they decide whether something earns a place in the profile.

### 1. Grounded in Schema.org

The term must exist in Schema.org, and the proposed usage should respect its `domainIncludes` (which classes the property attaches to) and `rangeIncludes` (which value types it accepts).

Schema.org’s domain and range are advisory – they do not constrain RDF validation, and Schema.org’s semantics are intentionally weak – but we follow them anyway, so that profile data also validates against Schema.org’s own type expectations and behaves predictably in consumers’ Schema.org tooling.
This is the same reason the profile co-types term values (for example adding `URL` alongside `DefinedTerm` for `material`).

Watch the **domain** in particular: a property whose natural domain is a *subclass* may not fit, because the profile models only the top-level classes (`CreativeWork`, `Person`, `Organization`, `Place`).
For example, `schema:height`, `width`, `depth` and `weight` list `VisualArtwork` – not `CreativeWork` – in their domain, so applying them to a bare `CreativeWork` would be off-domain.

### 2. Backed by evidence of real usage

Before adding anything, we check how widely it is actually used in the network, using the Dataset Knowledge Graph’s [property-partition analysis](https://triplestore.netwerkdigitaalerfgoed.nl/sparql?savedQueryName=Property%20partitions%20per%20class&owner=admin) (see the [Dataset Knowledge Graph](https://github.com/netwerk-digitaal-erfgoed/dataset-knowledge-graph)).

We look at how many datasets use the property, **on which class**, and **with which value types** – and compare that against the adoption of properties already in the profile as a rough bar.
A proposal should reflect a need shared across multiple datasets, not a single publisher’s. We run this verification ourselves rather than relying on the proposer.

### 3. Earns its place against simplicity

The curated minimal set is the profile’s main feature, so each addition must earn its place.
**Optional does not mean free:** a property a publisher can ignore is still one that every *consumer* has to learn, map and decide how to handle. Breadth therefore has a real cost even when nothing is required, and “it’s optional, so it does no harm” is not a sufficient argument for inclusion.

### 4. Offers convergence value

A profile exists to make datasets *converge*. A property earns its place when publishers express the same thing in divergent ways and one documented shape would unify them, or when consumers need a predictable shape to rely on.
If there is no divergence to fix and no consumer depending on it, prefer to defer.

### 5. Generic, not domain-specific

The profile is a *generic* model. Domain-specific nuance – qualified measurements, detailed provenance, discipline-specific structures – belongs in domain models such as CIDOC-CRM, Linked Art, RiC-O or RDA, which publishers may use alongside the profile.

Because the SHACL shapes are **open** (not `sh:closed`), publishers can already add properties the profile does not mention and still conform. So “not in the profile” never means “not allowed”: a niche need can often be met today without a profile change, which lowers the urgency of adding it.

### 6. Backward-compatible and stable

Within a major version the profile carries a backward-compatibility promise (see the changelog’s 1.0.0 entry): data that conforms today keeps conforming, so additions are backward-compatible – new properties are optional, and changes are additive, relaxing or clarifying.
Because a published shape is a long-term commitment, we add one only once it is clear and stable.

## Making the change

Edits are made to the source files, not the generated output:

- `shacl.ttl` – the SHACL shapes that are the single source of truth; the specification is built from them.
- `index.bs.liquid`, `node-shape.liquid`, `assets/class-diagram.mmd.liquid` – templates for the rendered document and diagram.
- `examples/` – JSON-LD examples, validated against the shapes.

Build the spec with `make spec` and validate the examples with `make validate` (see the [README](README.md)).
Both run in continuous integration on every pull request.

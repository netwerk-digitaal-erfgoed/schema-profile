# Changelog

## [1.0.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.16.0...1.0.0) (2026-06-01)

* First stable release, carrying a backward compatibility promise: within 1.x, data that conforms today keeps conforming and consumers that honour the must-ignore rule keep working – changes are additive, relaxing or clarifying, and anything that would invalidate conforming data waits for a 2.0.
* The constraint tightenings that set the stable baseline shipped in 0.16.0: `isPartOf` must reference a dataset by IRI, and `sdDatePublished` and `dateCreated` are single-valued.

## [0.16.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.15.1...0.16.0) (2026-06-01)


### ⚠ BREAKING CHANGES

* limit dateCreated to a single value
* limit sdDatePublished to a single value
* require isPartOf to reference a dataset by IRI

### Features

* limit dateCreated to a single value ([43665b6](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/43665b691d63dde2f786630609ba62ddbba83cf7))
* limit sdDatePublished to a single value ([eb619c1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/eb619c13e8a4b9a1d41fe36a691e77db7d39ce41))
* require isPartOf to reference a dataset by IRI ([8dac795](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/8dac795e4681741b514cf7fdb00b8199d4320854))

## [0.15.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.15.0...0.15.1) (2026-05-30)


### Bug Fixes

* use Linked Art in combined modelling example ([#161](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/161)) ([c0af88c](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/c0af88c6e8c8d3efc3a9ed9eafa9b85c83b2dc7e))

## [0.15.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.14.0...0.15.0) (2026-05-29)


### Features

* explain term co-typing ([0208413](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/0208413f42b3dcb139c30609da847bbf20e674a0))
* explain term equivalence ([9478442](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/9478442036827e09fa3f4d0511be1d8aa517d1bb))
* make Organization URI optional ([d09dc0f](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/d09dc0f8ba4a2a6d5940efb72bf63b05eae1e495))
* model additionalType as a DefinedTerm with sameAs ([ef49953](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/ef49953dd420929499c9872e098fa558f525a770))


### Documentation

* cross-reference DefinedTerm from the data-model section ([a92a27b](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/a92a27bc11b1e0c19202947b61d13bdffc987fa6))

## [0.14.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.13.0...0.14.0) (2026-05-21)


### Features

* make isPartOf and associatedMedia optional ([#153](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/153)) ([4926a21](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/4926a21739710e6b35e18a6b230d9d427eb3d76d))

## [0.13.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.12.0...0.13.0) (2026-05-21)


### Features

* make creator optional ([#152](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/152)) ([a216f98](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/a216f9849a5367105afe9e8d752d529673eb917a))
* require sdDatePublished on CreativeWork ([#150](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/150)) ([0e8480e](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/0e8480e271d08fa9ef68f6a61110d160ea56d7dd))

## [0.12.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.11.1...0.12.0) (2026-05-18)


### Features

* accept xsd:gYear and xsd:gYearMonth in DateShape ([#148](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/148)) ([ceb0589](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/ceb05899d61703b938e288a2aa0a97f03adee096))

## [0.11.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.11.0...0.11.1) (2026-05-14)


### Bug Fixes

* clarify associatedMedia IIIF wording ([#144](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/144)) ([4e9d2ec](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/4e9d2ecf4c9d9540c8cb0b487c4d9b4a5989fe14))

## [0.11.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.10.1...0.11.0) (2026-05-14)


### ⚠ BREAKING CHANGES

* drop isBasedOn requirement for IIIF Image API ([#142](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/142))

### Features

* drop isBasedOn requirement for IIIF Image API ([#142](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/142)) ([081f7a3](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/081f7a3ae970fb6f3f978f5937e750458ed383f1))
* **shacl:** split IIIF Presentation manifest into dedicated SHACL shape ([8d5d5b7](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/8d5d5b7c0fe5cf0c75eac0e04be34dac53b7adb6))


### Bug Fixes

* **examples:** comply with tightened SHACL constraints ([1e7718b](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/1e7718b104539dd1e436a362448128e586573db3))

## [0.10.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.10.0...0.10.1) (2026-05-13)


### Bug Fixes

* **examples:** use canonical CC0 1.0 URI ([#140](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/140)) ([9505184](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/9505184beee6712a88f6a7cc4c805e1dc1eca2df))

## [0.10.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.9.1...0.10.0) (2026-05-13)


### Features

* **shacl:** allow DefinedTerm without sameAs ([#138](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/138)) ([870f034](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/870f034fd23d382482f38579dad79e8f20eec58f))

## [0.9.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.9.0...0.9.1) (2026-04-29)


### Documentation

* **shacl:** clarify creator vs author and Role usage ([#133](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/133)) ([541e0e2](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/541e0e20c0b21a079b56d40eeff5d6720124b926))

## [0.9.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.8.1...0.9.0) (2026-04-20)


### Features

* **shacl:** tighten schema:temporalCoverage to ISO 8601 or HTTP(S) URI ([#131](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/131)) ([cfb13ca](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/cfb13ca7f2d5d0a44637bf36e52b416378148dad))

## [0.8.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.8.0...0.8.1) (2026-04-06)


### Bug Fixes

* clarify HTTPS namespace recommendation for existing datasets ([#129](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/129)) ([08c7c3d](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/08c7c3db4ca4839f077a54ed16961484460eeeb2))

## [0.8.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.7.2...0.8.0) (2026-04-02)


### Features

* switch to https://schema.org/ namespace ([#127](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/127)) ([22ff59a](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/22ff59a6689a2d97256bbd1d4882c195270e78b1))

## [0.7.2](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.7.1...0.7.2) (2026-03-16)


### Bug Fixes

* add URL co-type to material DefinedTerm for Schema.org validation ([#121](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/121)) ([6fa9fe0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/6fa9fe06aa5e40b5c56b7f7c2ca32c7358c70057))
* show multiple data platforms in overview diagram ([#123](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/123)) ([ada95c8](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/ada95c88a5c753be438a8c180dc2bcfb2cd60947))

## [0.7.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.7.0...0.7.1) (2026-03-10)


### Bug Fixes

* remove misleading publication method matrix ([#118](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/118)) ([a24613d](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/a24613d70084f431c9e38650fa8d593a326b14c7))

## [0.7.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.6.0...0.7.0) (2026-03-04)


### Features

* use schema:location instead of schema:address on Organization ([#115](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/115)) ([21b1fbe](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/21b1fbe5c51b269827ac1da70d06f104fd80edee))

## [0.6.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.5.0...0.6.0) (2026-03-04)


### Features

* move IIIF Presentation manifest from MediaObject to CreativeWork ([#111](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/111)) ([d0a2dae](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/d0a2daed460caf95cb5eb56d4df3e4c66c6d61d7))


### Bug Fixes

* add SHACL validation to reject info.json suffix in isBasedOn URI ([#109](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/109)) ([aa55f21](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/aa55f21b4ac5afbe018fd6ceca626bcc5d31af49))
* use IIIF Image API base URI without /info.json ([#107](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/107)) ([6a3f05c](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/6a3f05ce3c068695b8891cbe917e10d00a833e85))

## [0.5.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.4.1...0.5.0) (2026-03-02)


### Features

* Add DERA cross-references ([#105](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/105)) ([6334d9e](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/6334d9e5a5deb85d80b9904fc848b812e2d43ad4))

## [0.4.1](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.4.0...0.4.1) (2026-03-02)


### Bug Fixes

* metadata record definition ([97791a2](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/97791a27c64ad527a0956f30deb192acd5f429c9))
* remove incomplete example ([0b968e4](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/0b968e4d48b8d8a9432f7819480b1f9fafcdfcf4))

## [0.4.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/0.3.0...0.4.0) (2026-02-23)


### Features

* clarify allowed date formats in SHACL descriptions ([#101](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/101)) ([7ac5f18](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/7ac5f18f4faadb413f7011c1f15dad130b7dc4af))
* require sameAs on DefinedTerm, use Occupation as hasOccupation fallback ([#96](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/96)) ([bdddd80](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/bdddd80d7c126fcee3382464bdf48d576a158946))


### Bug Fixes

* merge CurrentPostalAddress and HistoricalPostalAddress ([#97](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/97)) ([c20ee9b](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/c20ee9b7e4257d69bd23a65f8d42bd92ff46ecb0))

## [0.3.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/v0.2.0...0.3.0) (2026-02-20)


### Features

* use sameAs for referencing terms ([#74](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/74)) ([045e748](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/045e7482efc6678b8c730b83f5b25c43abe6ba22))
* show spec version in header ([#93](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/93)) ([0e8bc58](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/0e8bc58235fdfb285c6ee7a9c53840228aca036a))


### Bug Fixes

* allow literal strings for sdo:hasOccupation ([#92](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/92)) ([166c5d5](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/166c5d5498c4e933c6452042d9f4ac3a039c6b42))
* use dual typing in term examples ([#94](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/94)) ([a24d070](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/a24d07023a2c9d4b29c248fe9268d383725e1e3c))

## [0.2.0](https://github.com/netwerk-digitaal-erfgoed/schema-profile/compare/v0.1.0...v0.2.0) (2026-02-20)


### Features

* allow untyped creator nodes ([#73](https://github.com/netwerk-digitaal-erfgoed/schema-profile/issues/73)) ([95ffa50](https://github.com/netwerk-digitaal-erfgoed/schema-profile/commit/95ffa50a18c2a110c54284a75cfddf35fece555f))

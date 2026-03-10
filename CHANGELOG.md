# Changelog

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

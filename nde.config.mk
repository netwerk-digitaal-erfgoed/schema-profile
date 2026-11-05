# Settings for the NDE spec boilerplate, which reads this file locally and in CI.

# The examples cite Schema.org’s context or the hosted profile context. Read both
# from this repository’s profile context, so the Turtle tabs show the triples
# this profile means, as make validate checks them.
NDE_JSONLD_CONTEXTS := https://schema.org=public/context.jsonld https://docs.nde.nl/schema-profile/context.jsonld=public/context.jsonld

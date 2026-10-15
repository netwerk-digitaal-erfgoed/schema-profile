# The build comes from netwerk-digitaal-erfgoed/workflows, at the version that
# this spec’s workflows pin for spec.yml, so a local build matches CI.
NDE_WORKFLOWS_DIR ?= .github/workflows
NDE_REF := $(shell sed -n -E 's,.*netwerk-digitaal-erfgoed/workflows/(\.github/workflows/spec\.yml|spec-boilerplate)@([^[:space:]]+).*,\2,p' $(NDE_WORKFLOWS_DIR)/*.yml | head -n 1)
include .nde/$(or $(NDE_REF),$(error No spec.yml version found in $(NDE_WORKFLOWS_DIR)))/spec-boilerplate/nde.mk

# Extracts into a temporary folder that is moved into place when complete, so an
# interrupted download never leaves a partial copy behind.
.nde/%/spec-boilerplate/nde.mk:
	rm -rf .nde/$* .nde/$*.download
	mkdir -p .nde/$*.download
	curl -fsSL -o .nde/$*.tar.gz https://github.com/netwerk-digitaal-erfgoed/workflows/archive/$*.tar.gz
	tar -xzf .nde/$*.tar.gz -C .nde/$*.download --strip-components=1
	rm .nde/$*.tar.gz
	mv .nde/$*.download .nde/$*

.PHONY: diagrams validate

# Renders the class diagram, which spec.yml does in CI, and strips the draw.io SVG
# fallback that Bikeshed mistakes for a dfn link.
spec watch: diagrams

diagrams: assets/class-diagram.mmd
	npx --yes -p @mermaid-js/mermaid-cli mmdc -i assets/class-diagram.mmd -o assets/class-diagram.svg --backgroundColor transparent --theme neutral
	sed -i '' 's/<switch><g requiredFeatures="http:\/\/www\.w3\.org\/TR\/SVG11\/feature#Extensibility"\/><a [^>]*><text[^>]*>[^<]*<\/text><\/a><\/switch>//g' assets/data-models.svg

# Validates the examples against the SHACL shape.
validate:
	./validate-examples.sh

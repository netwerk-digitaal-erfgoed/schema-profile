help:
	@echo "Generate HTML from a Bikeshed source document:"
	@echo "  make spec     Generate HTML"
	@echo "  make validate Validate examples against the SHACL shape"
	@echo "  make watch    Generate HTML each time the source changes"

spec:
	npx --yes @lde/docgen@latest from-shacl shacl.ttl index.bs.liquid > index.bs
	npx --yes @lde/docgen@latest from-shacl shacl.ttl ./assets/class-diagram.mmd.liquid > assets/class-diagram.mmd
	npx --yes -p @mermaid-js/mermaid-cli mmdc -i assets/class-diagram.mmd -o assets/class-diagram.svg --backgroundColor transparent --theme neutral
	@# Strip draw.io SVG fallback that Bikeshed mistakes for a dfn link.
	sed -i '' 's/<switch><g requiredFeatures="http:\/\/www\.w3\.org\/TR\/SVG11\/feature#Extensibility"\/><a [^>]*><text[^>]*>[^<]*<\/text><\/a><\/switch>//g' assets/data-models.svg
	docker run --rm -v "`pwd`:/spec" -w /spec netwerkdigitaalerfgoed/bikeshed:latest

validate:
	./validate-examples.sh

watch:
	docker run --rm -v "`pwd`:/spec" -w /spec netwerkdigitaalerfgoed/bikeshed:latest sh -c "bikeshed watch"

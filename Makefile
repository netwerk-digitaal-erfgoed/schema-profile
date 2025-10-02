help:
	@echo "Generate HTML from a Bikeshed source document:"
	@echo "  make spec    Generate HTML"
	@echo "  make watch   Generate HTML each time the source changes"

spec:
	npx --yes @lde/docgen@latest from-shacl shacl.ttl index.bs.liquid > index.bs
	npx --yes @lde/docgen@latest from-shacl shacl.ttl ./assets/class-diagram.mmd.liquid > assets/class-diagram.mmd
	npx --yes -p @mermaid-js/mermaid-cli mmdc -i assets/class-diagram.mmd -o assets/class-diagram.svg
	docker run --rm -v "`pwd`:/spec" -w /spec netwerkdigitaalerfgoed/bikeshed:5.3.2

watch:
	docker run --rm -v "`pwd`:/spec" -w /spec netwerkdigitaalerfgoed/bikeshed:5.3.2 sh -c "bikeshed watch"

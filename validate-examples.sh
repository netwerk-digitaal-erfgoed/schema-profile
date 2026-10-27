#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Output helpers
pass() { echo -e "${GREEN}PASS${NC} $1"; }
fail() { echo -e "${RED}FAIL${NC} $1"; }
warn() { echo -e "${YELLOW}$1${NC}"; }

# Check required commands
command -v shacl &>/dev/null || { fail "Error: shacl command not found. Please install Apache Jena."; exit 1; }
command -v sparql &>/dev/null || { fail "Error: SPARQL command not found. Please install Apache Jena ARQ."; exit 1; }
command -v riot &>/dev/null || { fail "Error: riot command not found. Please install Apache Jena."; exit 1; }

# Sanity-check the shapes file itself before validating any data against it.
# `set -e` aborts with the parser's stderr if either check fails.
echo "Parsing shacl.ttl..."
riot --validate shacl.ttl >/dev/null
shacl parse shacl.ttl >/dev/null

# Most examples cite Schema.org’s context, as publishers write them; some cite
# the hosted profile context, an inline context or Linked Art’s. Validate them
# the way a consumer reads them: with the profile context in place of
# Schema.org’s, which maps terms to http://schema.org/ and, since release 30.1,
# types no property, and in place of the hosted profile context. Use the copy
# in this repository, so a change to it is tested before release.
local_context="file://$PWD/public/context.jsonld"

# The profile context imports https://def.nde.nl/context.jsonld for the type
# coercions of Schema.org terms, which Schema.org’s own context dropped in
# release 30.1. Check that every coercion the shapes rely on still holds, so a
# change to the imported context cannot silently turn IRIs and dates into plain
# strings.
echo "Checking JSON-LD context coercions..."
coercions="/tmp/shacl-coercions.jsonld"
cat > "$coercions" <<EOF
{
  "@context": "$local_context",
  "@id": "https://example.org/work",
  "sameAs": "https://example.org/same",
  "contentUrl": "https://example.org/content",
  "license": "https://example.org/license",
  "isPartOf": "https://example.org/collection",
  "thumbnailUrl": "https://example.org/thumbnail",
  "url": "https://example.org/page",
  "dateCreated": "1642"
}
EOF
triples=$(riot --output=nt "$coercions")
for property in sameAs contentUrl license isPartOf thumbnailUrl url; do
    grep -q "<https://schema.org/$property> <" <<<"$triples" || { fail "$property does not expand to an IRI"; exit 1; }
done
grep -q '<https://schema.org/dateCreated> "1642"^^<https://schema.org/Date>' <<<"$triples" || { fail "dateCreated is not typed schema:Date"; exit 1; }

echo "Validating JSON-LD examples against SHACL shapes..."
echo "----------------------------------------"

# Counters
total=0
failed=0

# Validate all .jsonld files
for file in examples/*.jsonld; do
    [[ -f "$file" ]] || continue

    total=$((total + 1))
    basename=$(basename "$file")
    echo -n "Validating $basename... "

    # Create temp files (kept for debugging)
    data="/tmp/shacl-data-$basename.jsonld"
    report="/tmp/shacl-report-$basename.ttl"
    stderr="/tmp/shacl-stderr-$basename.txt"

    # Matches both a plain context and one inside an array, and also replaces the
    # hosted profile context, so examples that cite it test this checkout’s version.
    sed -E "s#\"https://(schema\\.org|docs\\.nde\\.nl/schema-profile/context\\.jsonld)\"#\"$local_context\"#" "$file" > "$data"

    # Run SHACL validation (don't let set -e abort the loop on shacl failure –
    # we want to surface its stderr and move on).
    set +e
    shacl validate --data "$data" --shapes shacl.ttl >"$report" 2>"$stderr"
    shacl_exit=$?
    set -e

    if [[ $shacl_exit -ne 0 ]]; then
        fail "(shacl exited $shacl_exit – could not validate)"
        warn "  shacl output:"
        sed 's/^/    /' "$stderr"
        echo
        failed=$((failed + 1))
        continue
    fi

    # Check for warnings first
    if grep -qi "warning" "$stderr"; then
        fail "(warnings detected)"
        warn "  Warnings:"
        grep -i "warning" "$stderr" | sed 's/^/    /'
        echo
        failed=$((failed + 1))
        continue
    fi

    # Check if validation passed completely
    if grep -q "sh:conforms.*true" "$report"; then
        pass
        continue
    fi

    # Pick the validation query: full real-world examples (story.jsonld) must
    # validate strictly, while pedagogical single-property examples are allowed
    # to omit unrelated required properties via the validate.rq path filter.
    if [[ "$basename" == "story.jsonld" ]]; then
        query=validate-strict.rq
        pass_suffix=""
    else
        query=validate.rq
        pass_suffix="(ignored missing required properties)"
    fi

    # Query for non-ignored violations. A query that fails to run returns no
    # rows, which must not be mistaken for an example without violations.
    query_stderr="/tmp/shacl-query-stderr-$basename.txt"
    set +e
    query_results=$(sparql --data "$report" --query "$query" --results TSV 2>"$query_stderr")
    sparql_exit=$?
    set -e

    if [[ $sparql_exit -ne 0 ]]; then
        fail "(sparql exited $sparql_exit – could not query the validation report)"
        warn "  sparql output:"
        sed 's/^/    /' "$query_stderr"
        echo
        failed=$((failed + 1))
        continue
    fi

    violations=$(echo "$query_results" | tail -n +2)

    if [[ -z "$violations" ]]; then
        pass "$pass_suffix"
    else
        count=$(echo "$violations" | wc -l | xargs)
        fail "($count non-ignored violations)"
        warn "  Violations:"
        echo "$violations" | while IFS=$'\t' read -r node path message; do
            echo "    Node: $node"
            echo "    Path: $path"
            echo "    Message: $message"
            echo
        done
        failed=$((failed + 1))
    fi
done

# Summary
echo "----------------------------------------"
echo "Validation Summary:"
echo "  Total: $total"
echo "  Passed: $((total - failed))"
echo "  Failed: $failed"
echo

if [[ $failed -gt 0 ]]; then
    fail "❌ Validation failed: $failed file(s) have violations"
    exit 1
else
    pass "✅ All files passed validation"
fi

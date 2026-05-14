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

    # Replace the JSON-LD context with one that produces https://schema.org/ IRIs
    # to match the SHACL shapes. Schema.org’s default context resolves terms to
    # http://schema.org/, but the AP standardises on https://. The custom context
    # uses @import to inherit Schema.org's type coercions (e.g. url, sameAs as
    # IRIs) while overriding the namespace.
    sed 's|"@context": "https://schema.org"|"@context": {"@version": 1.1, "@import": "https://schema.org/docs/jsonldcontext.jsonld", "@vocab": "https://schema.org/", "schema": "https://schema.org/"}|' "$file" > "$data"

    # Run SHACL validation (don't let set -e abort the loop on shacl failure —
    # we want to surface its stderr and move on).
    set +e
    shacl validate --data "$data" --shapes shacl.ttl >"$report" 2>"$stderr"
    shacl_exit=$?
    set -e

    if [[ $shacl_exit -ne 0 ]]; then
        fail "(shacl exited $shacl_exit — could not validate)"
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

    # Query for non-ignored violations
    violations=$(sparql --data "$report" --query "$query" --results TSV 2>/dev/null | tail -n +2)

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

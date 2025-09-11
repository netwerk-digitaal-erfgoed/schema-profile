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
    report="/tmp/shacl-report-$basename.ttl"
    stderr="/tmp/shacl-stderr-$basename.txt"

    # Run SHACL validation
    shacl validate --data "$file" --shapes shacl.ttl >"$report" 2>"$stderr"

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

    # Query for non-ignored violations
    violations=$(sparql --data "$report" --query validate.rq --results TSV 2>/dev/null | tail -n +2)

    if [[ -z "$violations" ]]; then
        pass "(ignored missing required properties)"
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

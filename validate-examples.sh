#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SPARQL_CMD="sparql"

# Counters
total_files=0
failed_files=0

echo "Validating JSON-LD examples against SHACL shapes..."
echo "Using SPARQL query to filter ignored properties"
echo "----------------------------------------"

# Check required commands
if ! command -v shacl &> /dev/null; then
    echo -e "${RED}Error: shacl command not found. Please install Apache Jena.${NC}"
    exit 1
fi

if ! command -v arq &> /dev/null && ! command -v sparql &> /dev/null; then
    echo -e "${RED}Error: SPARQL command not found. Please install Apache Jena ARQ.${NC}"
    exit 1
fi


# Function to validate a single file
validate_file() {
    local file="$1"
    local basename=$(basename "$file")
    local temp_report="/tmp/shacl-report-$basename.ttl"

    echo -n "Validating $basename... "

    # Run SHACL validation and save report to temp file
    shacl validate --data "$file" --shapes shacl.ttl > "$temp_report"

    # Check if the report indicates conformance
    if grep -q "sh:conforms.*true" "$temp_report"; then
        echo -e "${GREEN}PASS${NC}"
        rm -f "$temp_report"
        return 0
    fi

    # Query the validation report for non-ignored violations
    local violation_count
    violation_count=$($SPARQL_CMD --data "$temp_report" --query validate.rq --results CSV | tail -n +2 | cut -d, -f1 | tr -d '\r')

    # Check if there are any non-ignored violations
    if [[ -z "$violation_count" ]] || [[ "$violation_count" == "0" ]]; then
        echo -e "${GREEN}PASS${NC} (ignored missing required properties)"
        rm -f "$temp_report"
        return 0
    else
        echo -e "${RED}FAIL${NC} ($violation_count non-ignored violations)"
        
        # The SPARQL query already identified the real violations
        # For now, just indicate there are violations - detailed reporting could be added later
        echo "  Run 'shacl validate --data $file --shapes shacl.ttl --text' for details"
        echo

        rm -f "$temp_report"
        return 1
    fi
}

# Validate all .jsonld files in examples directory
if [[ ! -d "examples" ]]; then
    echo -e "${RED}Error: examples directory not found.${NC}"
    exit 1
fi

for file in examples/*.jsonld; do
    if [[ -f "$file" ]]; then
        total_files=$((total_files + 1))
        if ! validate_file "$file"; then
            failed_files=$((failed_files + 1))
        fi
        echo # Add blank line between files
    fi
done

# Summary
echo "----------------------------------------"
echo "Validation Summary:"
echo "Total files: $total_files"
echo "Passed: $((total_files - failed_files))"
echo "Failed: $failed_files"

if [[ $failed_files -gt 0 ]]; then
    echo -e "${RED}❌ Validation failed: $failed_files file(s) have violations${NC}"
    exit 1
else
    echo -e "${GREEN}✅ All files passed validation${NC}"
    exit 0
fi

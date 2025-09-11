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
        return 0
    fi

    # Query for non-ignored violations and capture the results
    local violations
    violations=$($SPARQL_CMD --data "$temp_report" --query <(cat <<'EOF'
PREFIX sh: <http://www.w3.org/ns/shacl#>
PREFIX schema: <http://schema.org/>

SELECT ?node ?path ?message
WHERE {
    ?report a sh:ValidationReport ;
        sh:result ?result .
    ?result sh:focusNode ?node ;
            sh:resultPath ?path ;
            sh:resultMessage ?message .
    
    # Filter out ignored properties
    FILTER (?path NOT IN (
         schema:name,
         schema:creator,
         schema:associatedMedia,
         schema:isPartOf,
         schema:license,
         schema:contentUrl,
         schema:thumbnailUrl
     ))
}
EOF
    ) --results TSV 2>/dev/null | tail -n +2)

    # Check if there are any non-ignored violations
    if [[ -z "$violations" ]]; then
        echo -e "${GREEN}PASS${NC} (ignored missing required properties)"
        return 0
    else
        # Count the violations for display
        local count=$(echo "$violations" | wc -l | tr -d ' ')
        echo -e "${RED}FAIL${NC} ($count non-ignored violations)"
        
        # Display the violations
        echo -e "${YELLOW}Violations:${NC}"
        echo "$violations" | while IFS=$'\t' read -r node path message; do
            echo "  Path: $path"
            echo "  Message: $message"
            echo
        done

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

#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Define the XML and XSD files
XSD_FILE="$SCRIPT_DIR/shiporder.xsd"
XML_FILE="$SCRIPT_DIR/shiporder.xml"

# Validate XML against XSD
xmllint --noout --schema "$XSD_FILE" "$XML_FILE"

# Check validation result
if [ $? -eq 0 ]; then
    echo "XML validation successful!"
else
    echo "XML validation failed!"
    exit 1
fi
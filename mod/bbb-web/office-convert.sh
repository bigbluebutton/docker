#!/bin/bash
# This script receives three params
# Param 1: Input office file path (e.g. "/tmp/test.odt")
# Param 2: Output pdf file path (e.g. "/tmp/test.pdf")
# Param 3: Destination Format (pdf default)
#If output format is missing, define PDF
convertTo="${3:-pdf}"

curl -v -X POST "http://jodconverter:8080/lool/convert-to/$convertTo" \
    -H "accept: application/octet-stream" \
    -H "Content-Type: multipart/form-data" \
    -F "data=@$1" > $2

exit 0
#!/bin/bash
# This script receives two params
# Param 1: Input office file path (e.g. "/tmp/test.odt")
# Param 2: Output pdf file path (e.g. "/tmp/test.pdf")

curl -v -X POST "http://jodconverter:8080/lool/convert-to/pdf" \
    -H "accept: application/octet-stream" \
    -H "Content-Type: multipart/form-data" \
    -F "data=@$1" > $2

exit 0
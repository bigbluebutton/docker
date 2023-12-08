#!/bin/sh
src="$8"
dest="$(echo $8 | sed -E -e 's/html|odt/'$7'/')"
convertTo="$7"


curl -v -X POST "http://jodconverter:8080/lool/convert-to/$convertTo" \
    -H "accept: application/octet-stream" \
    -H "Content-Type: multipart/form-data" \
    -F "data=@$src" > $dest

exit 0
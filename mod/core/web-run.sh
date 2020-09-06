#!/bin/bash

# forward libreoffice ports to this container
for i in `seq 1 4` ; do
    let PORT=8200+${i}
    echo "forward port $PORT to the libreoffice container"
    socat TCP-LISTEN:$PORT,fork TCP:10.7.7.7:$PORT &
done

java -Dgrails.env=prod -Dserver.address=0.0.0.0 -Dserver.port=8090 -Xms384m -Xmx384m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/var/bigbluebutton/diagnostics -cp WEB-INF/lib/*:/:WEB-INF/classes/:. org.springframework.boot.loader.WarLauncher



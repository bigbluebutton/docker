#!/bin/sh
set -e

for i in `seq 1 4` ; do

	SOFFICE_WORK_DIR="/var/tmp/soffice/instance_"`printf "%02d\n" ${i}`
	mkdir -p $SOFFICE_WORK_DIR
    chown bigbluebutton:bigbluebutton $SOFFICE_WORK_DIR

    # Initialize environment
    su-exec bigbluebutton /usr/lib/libreoffice/program/soffice.bin -env:UserInstallation="file:///tmp/office_${i}/"
done


for i in `seq 1 4` ; do
    let PORT=8200+${i}
    echo "start libreoffice on port ${PORT}"
    su-exec bigbluebutton  /usr/lib/libreoffice/program/soffice.bin --accept="socket,host=0.0.0.0,port=$PORT,tcpNoDelay=1;urp;StarOffice.ServiceManager" --headless --invisible --nocrashreport --nodefault --nofirststartwizard --nolockcheck --nologo --norestore -env:UserInstallation="file:///tmp/office_${i}/" &
done

wait $!

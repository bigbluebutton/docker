#!/bin/bash

#
# BlueButton open source conferencing system - http://www.bigbluebutton.org/
#
# Copyright (c) 2018 BigBlueButton Inc.
#
# This program is free software; you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 3.0 of the License, or (at your option) any later
# version.
#
# BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along
# with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
#
set -x

cd "$(dirname "$0")"

useradd bbb --uid 1099 -s /bin/bash
mkdir /home/bbb
chown bbb /home/bbb
echo "bbb ALL=(ALL:ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/bbb

echo "bbb:bbb" | chpasswd

# Allow to have executable files in /tmp/ folder (tomcat JNA)
mount /tmp -o remount,exec

./bbb-install.sh -d -s "`hostname -f`" -v xenial-220-dev22a -a
sed -i 's/::/0.0.0.0/g' /opt/freeswitch/etc/freeswitch/autoload_configs/event_socket.conf.xml

# Repository is broken (remove it later)
cd /usr/local/bigbluebutton/bbb-webrtc-sfu/
npm install --unsafe-perm

# Restart
bbb-conf --restart

# Update files
updatedb

# Tell system to not run this script again
touch /opt/docker-bbb/setup-executed

echo "BBB configuration completed.";
exit 0;


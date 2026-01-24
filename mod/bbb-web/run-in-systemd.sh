#!/bin/sh -e

# bbb-web requires a script under /usr/share/bbb-web/run-in-systemd.sh to run certain tasks
# this is used for sandboxing, which is in our case a bit more difficult, because
# we run it without systemd in an unprivileged container, with currently no extra sandboxing capabilities

# TODO: exploring better ways! (e. g. firejail)

timeout_secs="$1"; shift
exec timeout "${timeout_secs}" "$@"
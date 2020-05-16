#!/bin/bash

dockerize \
    -template /etc/freeswitch/vars.xml.tmpl:/etc/freeswitch/vars.xml \
    /usr/bin/freeswitch -u freeswitch -g daemon -nonat -nf

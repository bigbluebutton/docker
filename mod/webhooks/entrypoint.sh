#!/bin/sh

export NODE_ENV=production
cd /app
dockerize \
    -wait tcp://redis:6379 \
    -template /app/config/default.yml.tmpl:/app/config/default.yml \
    node app.js


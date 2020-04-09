#!/bin/bash

cd /app
export ROOT_URL=http://127.0.0.1/html5client
export MONGO_URL=mongodb://10.7.7.6/meteor
export NODE_ENV=production
export ENVIRONMENT_TYPE=production
export PORT=3000

node main.js

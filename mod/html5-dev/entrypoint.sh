set -e

# enable nvm
. /root/.nvm/nvm.sh

if [ -n  "$1" ]; then
    exec "$@"
else
    npm install
    npm start -- --host 0.0.0.0
fi
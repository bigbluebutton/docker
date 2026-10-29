#!/usr/bin/env bash
set -euo pipefail


SCHEMA_FILE=/usr/share/bbb-shared-notes-server/blocknote_schema.sql

export PGPASSWORD="$POSTGRES_PASSWORD"
psql_admin() {
  psql -h postgres -U postgres -v ON_ERROR_STOP=1 "$@"
}


# --- 1. Create user if not exists ---
user_exists=$(psql_admin -d postgres -tAc \
  "SELECT 1 FROM pg_roles WHERE rolname = 'blocknote_app'")
if [[ "$user_exists" == "1" ]]; then
  echo "User 'blocknote_app' already exists."
else
  echo "Creating user 'blocknote_app'..."
  # Use psql variables + :"name" / :'name' for safe quoting
  psql_admin -d postgres \
    -v app_user="blocknote_app" -v app_pass="blocknote_app" <<'SQL'
CREATE ROLE :"app_user" WITH LOGIN PASSWORD :'app_pass';
SQL
fi


# --- 2. Create database + import schema if database does not exist ---
db_exists=$(psql_admin -d postgres -tAc \
  "SELECT 1 FROM pg_database WHERE datname = 'blocknote_app'")

if [[ "$db_exists" == "1" ]]; then
  echo "Database 'blocknote_app' already exists. Skipping creation and schema import."
else
  echo "Creating database 'blocknote_app' owned by 'blocknote_app'..."
  psql_admin -d postgres -v app_db="blocknote_app" -v app_user="blocknote_app" <<'SQL'
CREATE DATABASE :"app_db" OWNER :"app_user";
SQL

  echo "Importing $SCHEMA_FILE..."
  # Import as the app user so objects are owned by it
  PGPASSWORD="blocknote_app" psql -h postgres -U "blocknote_app" \
    -d "blocknote_app" -v ON_ERROR_STOP=1 -f "$SCHEMA_FILE"

  echo "Done."
fi

echo "Starting bbb-shared-notes-server..."
node bbb-shared-notes-server.js
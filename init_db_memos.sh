#!/bin/bash

if [ -z "${MEMO_DB}" ]; then
  echo "MEMO_DB not set."
  return 1
fi

if [ -z "${MEMO_USER}" ]; then
  echo "MEMO_USER not set."
  return 1
fi

if [ -z "${MEMO_PASSWORD}" ]; then
  echo "MEMO_PASSWORD not set."
  return 1
fi

MEMO_DB="${MEMO_DB}"
MEMO_USER="${MEMO_USER}"
MEMO_PASSWORD="${MEMO_PASSWORD}"

sudo -u postgres psql -U postgres -c "CREATE USER $MEMO_USER WITH PASSWORD '$MEMO_PASSWORD';"
sudo -u postgres psql -U postgres -c "CREATE DATABASE $MEMO_DB;"
sudo -u postgres psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE $MEMO_DB TO $MEMO_USER;"
sudo -u postgres psql -U postgres -d $MEMO_DB -c "CREATE TABLE IF NOT EXISTS memos (id UUID PRIMARY KEY DEFAULT gen_random_uuid(), name VARCHAR NOT NULL, body VARCHAR);"
sudo -u postgres psql -U postgres -d $MEMO_DB -c "GRANT ALL PRIVILEGES ON TABLE memos TO $MEMO_USER;"

#!/bin/bash

mkdir -p db
echo 'populate db/main ...'
cat scripts/db_create_main.sql | sqlite3 db/main.db

#!/bin/bash

echo  'delete from minion_jobs;'  | sqlite3 db/minion.db


#!/usr/bin/env bash
set -e
FORCE_RECONFIGURE=1 postgres_configure

echo ">>> Creating replication user '$REPLICATION_USER'"
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "CREATE ROLE $REPLICATION_USER WITH REPLICATION PASSWORD '$REPLICATION_PASSWORD' SUPERUSER CREATEDB  CREATEROLE INHERIT LOGIN;"

echo ">>> Creating replication db '$REPLICATION_DB'"
createdb $REPLICATION_DB -O $REPLICATION_USER

#TODO: make it more flexible, allow set of IPs
#echo "host replication $REPLICATION_USER 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf
#echo "host all all 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf
echo "host all all 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf
echo "host replication replication 0.0.0.0/0 trust" >> $PGDATA/pg_hba.conf
echo "host replication replication_user 0.0.0.0/0 md5" >> $PGDATA/pg_hba.conf

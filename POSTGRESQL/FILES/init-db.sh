#!/bin/bash

set -e

echo PRIVATE KEY

cp /certs/demo.bortes.me/key.pem /var/lib/postgresql/data/key.pem
chmod 0600 /var/lib/postgresql/data/key.pem

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER user_db1 PASSWORD 'minha_senha';

    CREATE DATABASE db1;
    GRANT ALL PRIVILEGES ON DATABASE db1 TO user_db1;
EOSQL
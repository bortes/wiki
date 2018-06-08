#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo 2 CPU com 2 GB de RAM e 10 GB de espaço em disco [IGNORADO]

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    if ! type docker &> /dev/null; then
        echo Docker CE 18.03.0 ou superior [INSTALANDO]

        curl https://raw.githubusercontent.com/bortes/wiki/master/DOCKER/CE_FILES/run.sh | bash &> /dev/null
    fi
    echo Docker CE 18.03.0 ou superior [OK]

    if ! type docker-compose &> /dev/null; then
        echo Docker Compose 1.21.0 ou superior [INSTALANDO]

        curl https://raw.githubusercontent.com/bortes/wiki/master/DOCKER/COMPOSE_FILES/run.sh | bash &> /dev/null
    fi
    echo Docker Compose 1.21.0 ou superior [OK]

    if ! type certbot &> /dev/null; then
        echo Certbot 0.22.2 ou superior [INSTALANDO]

        curl https://raw.githubusercontent.com/bortes/wiki/master/TLS/CERTBOT_FILES/run.sh | bash &> /dev/null
    fi
    echo Certbot 0.22.2 ou superior [OK]

    true
}

# prepara a estrutura basica para utilizada repositorio
prepare_repo()
{
    echo
    echo REPOSITORIO

    mkdir -p /etc/opt/postgresql
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    if [ ! -d "/etc/letsencrypt/live/demo.bortes.me" ]; then
        certbot certonly --standalone --preferred-challenges http --agree-tos --no-eff-email --register-unsafely-without-email --domains demo.bortes.me
    fi
}

# executa a configuracao do software instalado
run_setup()
{
    echo
    echo CONFIGURACAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/POSTGRESQL/FILES/postgresql.conf -P /etc/opt/postgresql
    wget -N https://raw.githubusercontent.com/bortes/wiki/master/POSTGRESQL/FILES/pg_hba.conf -P /etc/opt/postgresql
    wget -N https://raw.githubusercontent.com/bortes/wiki/master/POSTGRESQL/FILES/init-db.sh -P /etc/opt/postgresql
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    wget -N https://raw.githubusercontent.com/bortes/wiki/master/POSTGRESQL/FILES/docker-compose.yml -P /etc/opt/postgresql

    docker-compose -f /etc/opt/postgresql/docker-compose.yml up -d
    docker-compose -f /etc/opt/postgresql/docker-compose.yml ps
}

# instala o software
install()
{
    if check_req; then
        prepare_repo
        run_install
        run_setup
        run
    fi
}

# acao padrao
install

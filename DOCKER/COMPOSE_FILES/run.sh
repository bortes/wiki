#!/bin/bash

# finaliza execucao quando ocorrer erro
set -e

# verifica os requisitos - por enquanto apenas verifica software instalado 
check_req()
{
    echo
    echo REQUISITOS

    echo Ubuntu 16.04 LTS ou superior [IGNORADO]

    if ! type docker &> /dev/null; then
        echo Docker CE 18.03.0 ou superior [INSTALANDO]
        
        curl https://raw.githubusercontent.com/bortes/wiki/master/DOCKER/CE_FILES/run.sh | bash &> /dev/null
    fi
    echo Docker CE 18.03.0 ou superior [OK]

    true
}

# executa a instalacao do software
run_install()
{
    echo
    echo INSTALACAO

    if ! type docker-compose &> /dev/null; then
        curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
}

# executa o software instalado
run()
{
    echo
    echo EXECUCAO

    docker-compose version
}

# instala o software
install()
{
    if check_req; then
        run_install
        run
    fi
}

# acao padrao
install
